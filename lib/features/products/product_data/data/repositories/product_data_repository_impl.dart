import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/products/product_data/data/datasources/product_data_local_data_source.dart';
import 'package:teriak/features/products/product_data/data/datasources/product_data_remote_data_source.dart';
import 'package:teriak/features/products/product_data/data/models/product_names_model.dart';
import 'package:teriak/features/products/product_data/domain/entities/product_names_entity.dart';

import '../../../../../core/connection/network_info.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../domain/entities/product_data_entity.dart';
import '../../domain/repositories/product_data_repository.dart';

class ProductDataRepositoryImpl extends ProductDataRepository {
  final NetworkInfo networkInfo;
  final ProductDataRemoteDataSource remoteDataSource;
  final ProductDataLocalDataSource localDataSource;

  ProductDataRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ProductDataEntity>>> getProductData({
    required ProductDataParams params,
  }) async {
    try {
      // Try to return cached data immediately if available (fast response)
      final cachedData = localDataSource.getCachedProductData(
        params.type,
        params.languageCode,
      );

      if (cachedData.isNotEmpty) {
        print(
            '📦 Returning ${cachedData.length} cached product data (type: ${params.type}, lang: ${params.languageCode})');

        // Update cache in background when online (non-blocking)
        final isConnected = await networkInfo.isConnected;
        if (isConnected) {
          remoteDataSource.getProductData(params).then((remoteData) async {
            // Cache the fetched data
            await localDataSource.cacheProductData(
              params.type,
              params.languageCode,
              remoteData,
            );
            print('🔄 Updated cached product data in background');
          }).catchError((e) {
            // Silently fail background update, we already have cached data
            print('⚠️ Background product data update failed: $e');
          });
        }

        // Convert models to entities (ProductDataModel extends ProductDataEntity, so this works)
        return Right(cachedData.map((e) => e as ProductDataEntity).toList());
      }

      // No cache available, fetch from remote
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(Failure(
          errMessage:
              'No cached product data available. Please connect to internet to load data first.'
                  .tr,
        ));
      }

      final result = await remoteDataSource.getProductData(params);

      // Cache the fetched data
      await localDataSource.cacheProductData(
        params.type,
        params.languageCode,
        result,
      );
      print('✅ Fetched and cached ${result.length} product data items');

      return Right(result);
    } on ServerException catch (e) {
      // If remote fails, try to return cached data as fallback
      final cachedData = localDataSource.getCachedProductData(
        params.type,
        params.languageCode,
      );
      if (cachedData.isNotEmpty) {
        print(
            '⚠️ Remote fetch failed, returning cached product data as fallback');
        return Right(cachedData);
      }

      return Left(Failure(
        errMessage: e.errorModel.errorMessage,
        statusCode: e.errorModel.status,
      ));
    } catch (e) {
      // If any other error, try to return cached data as fallback
      final cachedData = localDataSource.getCachedProductData(
        params.type,
        params.languageCode,
      );
      if (cachedData.isNotEmpty) {
        print('⚠️ Error occurred, returning cached product data as fallback');
        return Right(cachedData.map((e) => e as ProductDataEntity).toList());
      }

      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductNamesEntity>> getProductNames({
    required ProductNamesParams params,
  }) async {
    final type = params.type ?? '';

    try {
      // Try to return cached data immediately if available (fast response)
      final cachedNames = localDataSource.getCachedProductNames(
        type,
        params.id,
      );

      if (cachedNames != null) {
        print(
            '📦 Returning cached product names (type: $type, id: ${params.id})');

        // Update cache in background when online (non-blocking)
        final isConnected = await networkInfo.isConnected;
        if (isConnected) {
          remoteDataSource.getProductNames(params).then((remoteNames) async {
            // Cache the fetched names
            await localDataSource.cacheProductNames(
              type,
              params.id,
              remoteNames,
            );
            print('🔄 Updated cached product names in background');
          }).catchError((e) {
            // Silently fail background update, we already have cached data
            print('⚠️ Background product names update failed: $e');
          });
        }

        // Convert model to entity (ProductNamesModel extends ProductNamesEntity, so this works)
        return Right(cachedNames as ProductNamesEntity);
      }

      // No cache available, fetch from remote
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(Failure(
          errMessage:
              'No cached product names available. Please connect to internet to load data first.'
                  .tr,
        ));
      }

      final result = await remoteDataSource.getProductNames(params);

      // Cache the fetched names
      await localDataSource.cacheProductNames(
        type,
        params.id,
        result,
      );
      print('✅ Fetched and cached product names');

      return Right(result);
    } on ServerException catch (e) {
      // If remote fails, try to return cached data as fallback
      final cachedNames = localDataSource.getCachedProductNames(
        type,
        params.id,
      );
      if (cachedNames != null) {
        print(
            '⚠️ Remote fetch failed, returning cached product names as fallback');
        return Right(cachedNames);
      }

      return Left(Failure(
        errMessage: e.errorModel.errorMessage,
        statusCode: e.errorModel.status,
      ));
    } catch (e) {
      // If any other error, try to return cached data as fallback
      final cachedNames = localDataSource.getCachedProductNames(
        type,
        params.id,
      );
      if (cachedNames != null) {
        print('⚠️ Error occurred, returning cached product names as fallback');
        return Right(cachedNames as ProductNamesEntity);
      }

      return Left(Failure(errMessage: e.toString()));
    }
  }
}
