import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/products/all_products/data/datasources/product_local_data_source.dart';
import 'package:teriak/features/products/all_products/domain/entities/product_entity.dart';
import 'package:teriak/features/products/product_details/data/datasources/product_details_remote_data_source.dart';
import 'package:teriak/features/products/product_details/domain/repositories/product_details_repository.dart';

import '../../../../../core/connection/network_info.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class ProductDetailsRepositoryImpl extends ProductDetailsRepository {
  final NetworkInfo networkInfo;
  final ProductDetailsRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductDetailsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, ProductEntity>> getProductDetails(
      {required ProductDetailsParams params}) async {
    try {
      // Try to return cached product details immediately if available
      final cachedProduct = localDataSource.getCachedProductById(
          params.id, params.type ?? '');

      if (cachedProduct != null) {
        print(
            '📦 Returning cached product details for ID: ${params.id}, Type: ${params.type ?? ''}');

        // Update cache in background when online (non-blocking)
        final isConnected = await networkInfo.isConnected;
        if (isConnected) {
          remoteDataSource.getProductDetails(params).then((remoteProduct) async {
            // Cache the fetched product
            await localDataSource.cacheProduct(remoteProduct);
            print('🔄 Updated cached product details in background');
          }).catchError((e) {
            // Silently fail background update, we already have cached data
            print('⚠️ Background product details update failed: $e');
          });
        }

        return Right(cachedProduct);
      }

      // No cache available, fetch from remote
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(Failure(
          errMessage:
              'No cached product details available. Please connect to internet to load product details.'
                  .tr,
        ));
      }

      final result = await remoteDataSource.getProductDetails(params);

      // Cache the fetched product
      await localDataSource.cacheProduct(result);
      print('✅ Fetched and cached product details for ID: ${params.id}');

      return Right(result);
    } on ServerException catch (e) {
      // If remote fails, try to return cached data as fallback
      final cachedProduct = localDataSource.getCachedProductById(
          params.id, params.type ?? '');
      if (cachedProduct != null) {
        print('⚠️ Remote fetch failed, returning cached product details as fallback');
        return Right(cachedProduct);
      }

      return Left(Failure(
        errMessage: e.errorModel.errorMessage,
        statusCode: e.errorModel.status,
      ));
    } catch (e) {
      // If any other error, try to return cached data as fallback
      final cachedProduct = localDataSource.getCachedProductById(
          params.id, params.type ?? '');
      if (cachedProduct != null) {
        print('⚠️ Error occurred, returning cached product details as fallback');
        return Right(cachedProduct);
      }

      return Left(Failure(errMessage: e.toString()));
    }
  }
}
