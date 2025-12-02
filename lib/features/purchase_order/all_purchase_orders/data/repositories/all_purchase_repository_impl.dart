import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/datasources/purchase_order_local_data_source.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/purchase_model .dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/paginated_purchase_entity.dart';

import '../../../../../core/connection/network_info.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../domain/repositories/all_purchase_repository.dart';
import '../datasources/all_purchase_remote_data_source.dart';

class AllPurchaseOrdersRepositoryImpl extends AllPurchaseOrdersRepository {
  final NetworkInfo networkInfo;
  final AllPurchaseOrdersRemoteDataSource remoteDataSource;
  final PurchaseOrderLocalDataSource localDataSource;

  AllPurchaseOrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, PaginatedPurchaseOrderEntity>> getAllPurchaseOrders(
      {required PaginationParams params}) async {
    try {
      // Try to return cached data immediately if available (fast response)
      final cachedData = localDataSource.getCachedPurchaseOrdersPaginated(
        page: params.page,
        size: params.size,
      );

      if (cachedData.content.isNotEmpty) {
        print(
            '📦 Returning ${cachedData.content.length} cached purchase orders (page ${params.page})');

        // Update cache in background when online (non-blocking)
        // Use unawaited to ensure it doesn't block and errors are completely isolated
        final isConnected = await networkInfo.isConnected;
        if (isConnected) {
          // Isolate background update completely - any errors should not affect the main flow
          Future.microtask(() async {
            try {
              final remoteData =
                  await remoteDataSource.getAllPurchaseOrders(params);
              await localDataSource.cachePurchaseOrders(
                remoteData.content.map((e) => e as PurchaseOrderModel).toList(),
              );
              print('🔄 Updated cached purchase orders in background');
            } catch (e) {
              // Silently fail background update, we already have cached data
              print('⚠️ Background purchase order update failed: $e');
            }
          });
        }

        return Right(cachedData);
      }

      // No cache available, fetch from remote
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(Failure(
          errMessage:
              'No cached purchase order data available. Please connect to internet to load purchase orders first.',
        ));
      }

      final remoteData = await remoteDataSource.getAllPurchaseOrders(params);

      // Cache the fetched purchase orders
      await localDataSource.cachePurchaseOrders(
        remoteData.content.map((e) => e as PurchaseOrderModel).toList(),
      );
      print(
          '✅ Fetched and cached ${remoteData.content.length} purchase orders');

      return Right(remoteData);
    } on UnauthorizedException catch (e) {
      // For 401 errors, still try to return cached data as fallback
      final cachedData = localDataSource.getCachedPurchaseOrdersPaginated(
        page: params.page,
        size: params.size,
      );
      if (cachedData.content.isNotEmpty) {
        print(
            '⚠️ Unauthorized (401), returning ${cachedData.content.length} cached purchase orders as fallback');
        return Right(cachedData);
      }

      // If no cached data, return the error
      return Left(Failure(
        errMessage: e.errorModel.errorMessage,
        statusCode: e.errorModel.status,
      ));
    } on ServerException catch (e) {
      // If remote fails, try to return cached data as fallback
      final cachedData = localDataSource.getCachedPurchaseOrdersPaginated(
        page: params.page,
        size: params.size,
      );
      if (cachedData.content.isNotEmpty) {
        print(
            '⚠️ Remote fetch failed, returning ${cachedData.content.length} cached purchase orders as fallback');
        return Right(cachedData);
      }

      return Left(Failure(
        errMessage: e.errorModel.errorMessage,
        statusCode: e.errorModel.status,
      ));
    } catch (e) {
      // If any other error, try to return cached data as fallback
      final cachedData = localDataSource.getCachedPurchaseOrdersPaginated(
        page: params.page,
        size: params.size,
      );
      if (cachedData.content.isNotEmpty) {
        print(
            '⚠️ Error occurred, returning ${cachedData.content.length} cached purchase orders as fallback');
        return Right(cachedData);
      }

      return Left(Failure(errMessage: e.toString()));
    }
  }
}
