import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/products/all_products/data/datasources/product_remote_data_source.dart';
import 'package:teriak/features/products/all_products/data/datasources/product_local_data_source.dart';
import 'package:teriak/features/products/all_products/data/models/product_model.dart';
import 'package:teriak/features/products/all_products/domain/entities/paginated_products_entity.dart';
import 'package:teriak/features/products/all_products/domain/repositories/product_repository.dart';

import '../../../../../core/connection/network_info.dart';

import '../../../../../core/errors/failure.dart';

class ProductRepositoryImpl extends ProductRepository {
  final NetworkInfo networkInfo;
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PaginatedProductsEntity>> getAllProduct({
    required AllProductParams params,
    bool skipCache = false,
  }) async {
    try {
      // If skipCache is true, fetch directly from remote
      if (skipCache) {
        final isConnected = await networkInfo.isConnected;
        if (!isConnected) {
          // If offline and skipCache, try to return cached data as fallback
          final cachedProducts = localDataSource.getCachedProductsPaginated(
            page: params.page,
            size: params.size,
          );
          if (cachedProducts.content.isNotEmpty) {
            print(
                '⚠️ Offline and skipCache requested, returning cached products as fallback');
            return Right(cachedProducts);
          }
          return Left(Failure(
            errMessage:
                'No cached product data available. Please connect to internet to load products.'
                    .tr,
          ));
        }

        final result = await remoteDataSource.getAllProduct(params);
        // Cache the fetched products
        final productsToCache =
            result.content.whereType<ProductModel>().toList();
        print(
            '📥 API returned ${productsToCache.length} products for page ${params.page}');
        await localDataSource.cacheProducts(productsToCache);
        // Clean up any duplicates that might exist
        await localDataSource.clearDuplicateProducts();
        print(
            '✅ Fetched and cached ${productsToCache.length} products (skipCache=true). Total in cache after cleanup: ${result.totalElements}');
        return Right(result);
      }

      // Try to return cached data immediately if available (fast response)
      final cachedProducts = localDataSource.getCachedProductsPaginated(
        page: params.page,
        size: params.size,
      );

      if (cachedProducts.content.isNotEmpty) {
        print(
            '📦 Returning ${cachedProducts.content.length} cached products (page ${params.page})');

        // Update cache in background when online (non-blocking)
        final isConnected = await networkInfo.isConnected;
        if (isConnected) {
          remoteDataSource.getAllProduct(params).then((remoteProducts) async {
            // Cache the fetched products (cast to ProductModel since they are ProductModel at runtime)
            final productsToCache =
                remoteProducts.content.whereType<ProductModel>().toList();
            await localDataSource.cacheProducts(productsToCache);
            print('🔄 Updated cached products in background');
          }).catchError((e) {
            // Silently fail background update, we already have cached data
            print('⚠️ Background product update failed: $e');
          });
        }

        return Right(cachedProducts);
      }

      // No cache available, fetch from remote
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(Failure(
          errMessage:
              'No cached product data available. Please connect to internet to load products first.'
                  .tr,
        ));
      }

      final result = await remoteDataSource.getAllProduct(params);

      // Cache the fetched products (cast to ProductModel since they are ProductModel at runtime)
      final productsToCache = result.content.whereType<ProductModel>().toList();
      await localDataSource.cacheProducts(productsToCache);
      // Clean up any duplicates that might exist
      await localDataSource.clearDuplicateProducts();
      print('✅ Fetched and cached ${productsToCache.length} products');

      return Right(result);
    } on ServerException catch (e) {
      // If remote fails, try to return cached data as fallback
      final cachedProducts = localDataSource.getCachedProductsPaginated(
        page: params.page,
        size: params.size,
      );
      if (cachedProducts.content.isNotEmpty) {
        print('⚠️ Remote fetch failed, returning cached products as fallback');
        return Right(cachedProducts);
      }

      return Left(Failure(
        errMessage: e.errorModel.errorMessage,
        statusCode: e.errorModel.status,
      ));
    } catch (e) {
      // If any other error, try to return cached data as fallback
      final cachedProducts = localDataSource.getCachedProductsPaginated(
        page: params.page,
        size: params.size,
      );
      if (cachedProducts.content.isNotEmpty) {
        print('⚠️ Error occurred, returning cached products as fallback');
        return Right(cachedProducts);
      }

      return Left(Failure(errMessage: e.toString()));
    }
  }
}
