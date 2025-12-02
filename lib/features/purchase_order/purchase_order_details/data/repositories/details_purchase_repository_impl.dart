import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/data/models/hive_pending_purchase_order_model.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/datasources/purchase_order_local_data_source.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/purchase_entity%20.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/product_item_entity.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/controller/all_supplier_controller.dart';
import 'package:teriak/features/products/all_products/presentation/controller/get_allProduct_controller.dart';

import '../../../../../core/connection/network_info.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

import '../../domain/repositories/details_purchase_repository.dart';
import '../datasources/details_purchase_remote_data_source.dart';

class DetailsPurchaseOrdersRepositoryImpl
    extends DetailsPurchaseOrdersRepository {
  final NetworkInfo networkInfo;
  final DetailsPurchaseOrdersRemoteDataSource remoteDataSource;
  final PurchaseOrderLocalDataSource localDataSource;

  DetailsPurchaseOrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, PurchaseOrderEntity>> getDetailsPurchaseOrders(
      {required DetailsPurchaseOrdersParams params}) async {
    try {
      // First, check if this is a pending offline order
      try {
        final pendingBox =
            Hive.box<HivePendingPurchaseOrderModel>('pendingPurchaseOrders');
        final pendingOrder = pendingBox.get(params.id);

        if (pendingOrder != null) {
          print('📦 Found pending offline order: ID ${params.id}');

          // Convert pending order to entity
          final supplierId = pendingOrder.body['supplierId'] ?? 0;
          // Get supplier name from body (stored when creating offline order)
          String supplierName = pendingOrder.body['supplierName'] as String? ??
              'Unknown Supplier';

          // If not in body, try to get from supplier controller as fallback
          if (supplierName == 'Unknown Supplier') {
            try {
              if (Get.isRegistered<GetAllSupplierController>()) {
                final supplierController = Get.find<GetAllSupplierController>();
                final supplier = supplierController.suppliers.firstWhereOrNull(
                  (s) => s.id == supplierId,
                );
                if (supplier != null) {
                  supplierName = supplier.name;
                }
              }
            } catch (e) {
              print('⚠️ Could not get supplier name: $e');
            }
          }

          final offlineOrder = PurchaseOrderEntity(
            id: pendingOrder.id,
            supplierId: supplierId,
            supplierName: supplierName,
            currency: pendingOrder.body['currency'] ?? 'SYP',
            total: _calculateTotalFromItems(pendingOrder.body['items'] ?? []),
            status: pendingOrder.status,
            createdAt: _parseDateTimeFromString(pendingOrder.createdAt),
            items: _convertItemsToEntities(pendingOrder.body['items'] ?? []),
          );

          return Right(offlineOrder);
        }
      } catch (e) {
        print('⚠️ Error checking pending orders: $e');
      }

      // Try to return cached data immediately if available (fast response)
      final cachedPurchaseOrder =
          localDataSource.getCachedPurchaseOrderById(params.id);

      if (cachedPurchaseOrder != null) {
        print('📦 Returning cached purchase order details: ID ${params.id}');

        // Update cache in background when online (non-blocking)
        final isConnected = await networkInfo.isConnected;
        if (isConnected) {
          remoteDataSource
              .getDetailsPurchaseOrders(params)
              .then((remoteData) async {
            await localDataSource.cachePurchaseOrder(remoteData);
            print('🔄 Updated cached purchase order details in background');
          }).catchError((e) {
            // Silently fail background update, we already have cached data
            print('⚠️ Background purchase order details update failed: $e');
          });
        }

        return Right(cachedPurchaseOrder);
      }

      // No cache available, fetch from remote
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(Failure(
          errMessage:
              'No cached purchase order data available. Please connect to internet to load purchase order details first.',
        ));
      }

      final remoteDetailsPurchaseOrders =
          await remoteDataSource.getDetailsPurchaseOrders(params);

      // Cache the fetched purchase order details
      await localDataSource.cachePurchaseOrder(remoteDetailsPurchaseOrders);
      print('✅ Fetched and cached purchase order details: ID ${params.id}');

      return Right(remoteDetailsPurchaseOrders);
    } on ServerException catch (e) {
      // If remote fails, try to return cached data as fallback
      final cachedPurchaseOrder =
          localDataSource.getCachedPurchaseOrderById(params.id);
      if (cachedPurchaseOrder != null) {
        print(
            '⚠️ Remote fetch failed, returning cached purchase order details as fallback');
        return Right(cachedPurchaseOrder);
      }

      return Left(Failure(
        errMessage: e.errorModel.errorMessage,
        statusCode: e.errorModel.status,
      ));
    } catch (e) {
      // If any other error, try to return cached data as fallback
      final cachedPurchaseOrder =
          localDataSource.getCachedPurchaseOrderById(params.id);
      if (cachedPurchaseOrder != null) {
        print(
            '⚠️ Error occurred, returning cached purchase order details as fallback');
        return Right(cachedPurchaseOrder);
      }

      return Left(Failure(errMessage: e.toString()));
    }
  }

  double _calculateTotalFromItems(List<dynamic> items) {
    return items.fold<double>(
      0.0,
      (sum, item) => sum + ((item['quantity'] ?? 0) * (item['price'] ?? 0.0)),
    );
  }

  List<int> _parseDateTimeFromString(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return [
        date.year,
        date.month,
        date.day,
        date.hour,
        date.minute,
        date.second
      ];
    } catch (e) {
      final now = DateTime.now();
      return [now.year, now.month, now.day, now.hour, now.minute, now.second];
    }
  }

  List<ProductItemEntity> _convertItemsToEntities(List<dynamic> items) {
    return items.map((item) {
      final productId = item['productId'] ?? 0;

      // First, try to get product information from item data (stored when creating offline order)
      String productName = item['productName'] as String? ?? 'Unknown Product';
      String barcode = item['barcode'] as String? ?? '';
      double? refSellingPrice = (item['refSellingPrice'] as num?)?.toDouble();
      int? minStockLevel = item['minStockLevel'] as int?;

      // If product information is not in item data, try to get from product controller as fallback
      if (productName == 'Unknown Product' || barcode.isEmpty) {
        try {
          if (Get.isRegistered<GetAllProductController>()) {
            final productController = Get.find<GetAllProductController>();
            final product = productController.products.firstWhereOrNull(
              (p) => p.id == productId,
            );
            if (product != null) {
              if (productName == 'Unknown Product') {
                productName = product.tradeName.isNotEmpty
                    ? product.tradeName
                    : product.scientificName.isNotEmpty
                        ? product.scientificName
                        : 'Unknown Product';
              }
              if (barcode.isEmpty) {
                barcode = product.barcode;
              }
              if (refSellingPrice == null) {
                refSellingPrice = product.refSellingPrice;
              }
              if (minStockLevel == null) {
                minStockLevel = product.minStockLevel;
              }
            }
          }
        } catch (e) {
          print('⚠️ Could not get product details: $e');
        }
      }

      return ProductItemEntity(
        id: productId,
        productId: productId,
        productName: productName,
        quantity: item['quantity'] ?? 0,
        price: (item['price'] as num?)?.toDouble() ?? 0.0,
        productType: item['productType'] as String? ?? '',
        barcode: barcode,
        refSellingPrice: refSellingPrice,
        minStockLevel: minStockLevel,
      );
    }).toList();
  }
}
