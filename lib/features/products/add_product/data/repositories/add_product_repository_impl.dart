import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/products/add_product/data/datasources/add_product_local_data_source.dart';
import 'package:teriak/features/products/add_product/data/datasources/add_product_remote_data_source.dart';
import 'package:teriak/features/products/add_product/data/models/hive_pending_product_model.dart';
import 'package:teriak/features/products/add_product/domain/repositories/add_product_repository.dart';
import 'package:teriak/features/products/all_products/data/datasources/product_local_data_source.dart';
import 'package:teriak/features/products/all_products/domain/entities/product_entity.dart';

import '../../../../../core/connection/network_info.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class AddProductRepositoryImpl extends AddProductRepository {
  final NetworkInfo networkInfo;
  final AddProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final AddProductLocalDataSource pendingProductLocalDataSource;

  AddProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.pendingProductLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProductEntity>> postAddProduct(
      {required AddProductParams params,
      required Map<String, dynamic> body}) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final remoteAddProduct =
            await remoteDataSource.postAddProduct(params, body);

        // Cache the newly added product
        await localDataSource.cacheProduct(remoteAddProduct);
        print('✅ Cached newly added product');

        return Right(remoteAddProduct);
      } on ServerException catch (e) {
        print(e.errorModel.status);
        return Left(Failure(
          errMessage: e.errorModel.errorMessage,
          statusCode: e.errorModel.status,
        ));
      }
    } else {
      // Save product offline
      try {
        final pendingProduct = HivePendingProductModel.fromProductData(
          languageCode: params.languageCode,
          body: body,
        );

        await pendingProductLocalDataSource.savePendingProduct(pendingProduct);
        print('✅ Product saved offline, will sync when back online');

        // Create a temporary product entity for offline product
        // This allows the UI to show success even when offline
        final offlineProduct = ProductEntity(
          id: pendingProduct.id,
          tradeName: body['tradeName'] ?? '',
          scientificName: body['scientificName'] ?? '',
          barcodes: body['barcodes'] ?? [],
          barcode: (body['barcodes'] as List?)?.isNotEmpty == true
              ? (body['barcodes'] as List).first.toString()
              : '',
          productType: 'Pharmacy', // Default, will be updated on sync
          requiresPrescription: body['requiresPrescription'] ?? false,
          concentration: body['concentration'] ?? '',
          size: body['size'] ?? '',
          type: null,
          form: '',
          manufacturer: null,
          notes: body['notes'],
          refPurchasePrice: 0,
          refSellingPrice: 0,
          refPurchasePriceUSD: 0,
          refSellingPriceUSD: 0,
          minStockLevel: null,
          quantity: 0,
          categories: body['categoryIds'] ?? [],
        );

        return Right(offlineProduct);
      } catch (e) {
        return Left(Failure(
          errMessage: 'Failed to save product offline: $e',
        ));
      }
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> syncPendingProducts() async {
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(Failure(
        errMessage: 'No internet connection. Cannot sync pending products.'.tr,
      ));
    }

    try {
      final pendingProducts =
          pendingProductLocalDataSource.getPendingProducts();
      if (pendingProducts.isEmpty) {
        return Right([]);
      }

      final syncedProducts = <ProductEntity>[];
      final failedProducts = <HivePendingProductModel>[];

      for (final pendingProduct in pendingProducts) {
        try {
          final params = AddProductParams(
            languageCode: pendingProduct.languageCode,
          );

          // Create product on server
          final remoteProduct = await remoteDataSource.postAddProduct(
            params,
            pendingProduct.body,
          );

          // Cache the synced product
          await localDataSource.cacheProduct(remoteProduct);

          // Remove pending product after successful sync
          await pendingProductLocalDataSource.deletePendingProduct(
            pendingProduct.id,
          );

          syncedProducts.add(remoteProduct);
          print('✅ Synced pending product (ID: ${pendingProduct.id})');

          // Clean up duplicates after each sync
          await localDataSource.clearDuplicateProducts();
        } on ConflictException {
          // Product already exists on server (barcode conflict)
          // This is not a failure - the product is already there
          // Remove the pending product since it's already on the server
          await pendingProductLocalDataSource.deletePendingProduct(
            pendingProduct.id,
          );
          print(
              'ℹ️ Pending product ${pendingProduct.id} already exists on server (barcode conflict), removed from pending list');
          // Don't add to failedProducts - it's not a failure
        } catch (e) {
          // Keep failed products for retry later
          failedProducts.add(pendingProduct);
          print('⚠️ Failed to sync pending product ${pendingProduct.id}: $e');
        }
      }

      if (failedProducts.isNotEmpty && syncedProducts.isEmpty) {
        return Left(Failure(
          errMessage:
              'Failed to sync all pending products. ${failedProducts.length} products failed.'
                  .tr,
        ));
      }

      // Clean up duplicates after all syncs are complete
      await localDataSource.clearDuplicateProducts();
      print('🧹 Cleaned up duplicates after sync');

      return Right(syncedProducts);
    } catch (e) {
      return Left(Failure(
        errMessage: 'Failed to sync pending products: $e',
      ));
    }
  }

  @override
  int getPendingProductsCount() {
    return pendingProductLocalDataSource.getPendingProductsCount();
  }
}
