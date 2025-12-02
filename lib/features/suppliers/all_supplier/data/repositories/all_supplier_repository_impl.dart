import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/suppliers/all_supplier/data/datasources/all_supplier_remote_data_source.dart';
import 'package:teriak/features/suppliers/all_supplier/data/datasources/supplier_local_data_source.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import 'package:teriak/features/suppliers/all_supplier/domain/repositories/all_supplier_repository.dart';
import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';

class AllSupplierRepositoryImpl extends AllSupplierRepository {
  final NetworkInfo networkInfo;
  final AllSupplierRemoteDataSource remoteDataSource;
  final SupplierLocalDataSource localDataSource;

  AllSupplierRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<SupplierModel>>> getAllSupplier({bool skipCache = false}) async {
    try {
      // If skipCache is true, fetch directly from remote
      if (skipCache) {
        final isConnected = await networkInfo.isConnected;
        if (!isConnected) {
          // If offline and skipCache, try to return cached data as fallback
          final cachedSuppliers = localDataSource.getCachedSuppliers();
          if (cachedSuppliers.isNotEmpty) {
            print('⚠️ Offline and skipCache requested, returning cached suppliers as fallback');
            return Right(cachedSuppliers.map((e) => SupplierModel(
              id: e.id,
              name: e.name,
              phone: e.phone,
              address: e.address,
              preferredCurrency: e.preferredCurrency,
            )).toList());
          }
          return Left(Failure(
            errMessage: 'No cached supplier data available. Please connect to internet to load suppliers.'.tr,
          ));
        }

        final result = await remoteDataSource.getAllSupplier();
        // Cache the fetched suppliers
        await localDataSource.cacheSuppliers(result);
        print('✅ Fetched and cached ${result.length} suppliers (skipCache=true)');
        return Right(result);
      }

      // Try to return cached data immediately if available (fast response)
      final cachedSuppliers = localDataSource.getCachedSuppliers();

      if (cachedSuppliers.isNotEmpty) {
        print('📦 Returning ${cachedSuppliers.length} cached suppliers');

        // Update cache in background when online (non-blocking)
        final isConnected = await networkInfo.isConnected;
        if (isConnected) {
          remoteDataSource.getAllSupplier().then((remoteSuppliers) async {
            await localDataSource.cacheSuppliers(remoteSuppliers);
            print('🔄 Updated cached suppliers in background');
          }).catchError((e) {
            // Silently fail background update, we already have cached data
            print('⚠️ Background supplier update failed: $e');
          });
        }

        return Right(cachedSuppliers.map((e) => SupplierModel(
          id: e.id,
          name: e.name,
          phone: e.phone,
          address: e.address,
          preferredCurrency: e.preferredCurrency,
        )).toList());
      }

      // No cache available, fetch from remote
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(Failure(
          errMessage: 'No cached supplier data available. Please connect to internet to load suppliers first.'.tr,
        ));
      }

      final result = await remoteDataSource.getAllSupplier();

      // Cache the fetched suppliers
      await localDataSource.cacheSuppliers(result);
      print('✅ Fetched and cached ${result.length} suppliers');

      return Right(result);
    } on ServerException catch (e) {
      // If remote fails, try to return cached data as fallback
      final cachedSuppliers = localDataSource.getCachedSuppliers();
      if (cachedSuppliers.isNotEmpty) {
        print('⚠️ Remote fetch failed, returning cached suppliers as fallback');
        return Right(cachedSuppliers.map((e) => SupplierModel(
          id: e.id,
          name: e.name,
          phone: e.phone,
          address: e.address,
          preferredCurrency: e.preferredCurrency,
        )).toList());
      }

      return Left(Failure(
        errMessage: e.errorModel.errorMessage,
        statusCode: e.errorModel.status,
      ));
    } catch (e) {
      // If any other error, try to return cached data as fallback
      final cachedSuppliers = localDataSource.getCachedSuppliers();
      if (cachedSuppliers.isNotEmpty) {
        print('⚠️ Error occurred, returning cached suppliers as fallback');
        return Right(cachedSuppliers.map((e) => SupplierModel(
          id: e.id,
          name: e.name,
          phone: e.phone,
          address: e.address,
          preferredCurrency: e.preferredCurrency,
        )).toList());
      }

      return Left(Failure(errMessage: e.toString()));
    }
  }
}
