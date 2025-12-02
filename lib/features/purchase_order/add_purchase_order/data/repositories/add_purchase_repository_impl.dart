import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/data/datasources/add_purchase_local_data_source.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/data/datasources/add_purchase_remote_data_source.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/data/models/hive_pending_purchase_order_model.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/datasources/purchase_order_local_data_source.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/purchase_entity%20.dart';
import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../domain/repositories/add_purchase_repository.dart';

class AddPurchaseOrderRepositoryImpl extends AddPurchaseOrderRepository {
  final NetworkInfo networkInfo;
  final AddPurchaseOrderRemoteDataSource remoteDataSource;
  final PurchaseOrderLocalDataSource localDataSource;
  final AddPurchaseOrderLocalDataSource pendingPurchaseOrderLocalDataSource;

  AddPurchaseOrderRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
    required this.pendingPurchaseOrderLocalDataSource,
  });

  @override
  Future<Either<Failure, PurchaseOrderEntity>> postAddPurchaseOrder(
      {required LanguageParam params,
      required Map<String, dynamic> body}) async {
    try {
      print('🔄 Checking network connection...');
      final isConnected = await networkInfo.isConnected;
      print('📡 Network connected: $isConnected');

      if (isConnected) {
        try {
          print('📤 Sending purchase order to server...');
          print('📤 Body: $body');

          final remoteAddPurchaseOrder =
              await remoteDataSource.postAddPurchaseOrder(params, body);

          print('✅ Server response received: ID ${remoteAddPurchaseOrder.id}');

          // Cache the newly created purchase order immediately
          // This ensures it appears in the list when refreshed
          await localDataSource.cachePurchaseOrder(remoteAddPurchaseOrder);
          print(
              '✅ Cached newly created purchase order: ID ${remoteAddPurchaseOrder.id}');
          print(
              '📦 Purchase order is now available in cache and will appear in the list');

          return Right(remoteAddPurchaseOrder);
        } on ServerException catch (e) {
          print('❌ Server error: ${e.errorModel.errorMessage}');
          print('❌ Status code: ${e.errorModel.status}');
          return Left(Failure(
            errMessage: e.errorModel.errorMessage,
            statusCode: e.errorModel.status,
          ));
        } catch (e, stackTrace) {
          print('❌ Unexpected error creating purchase order: $e');
          print('❌ Stack trace: $stackTrace');
          return Left(Failure(
            errMessage: 'Failed to create purchase order: $e',
          ));
        }
      } else {
        // Save purchase order offline
        try {
          print('💾 Saving purchase order offline...');
          final pendingPurchaseOrder =
              HivePendingPurchaseOrderModel.fromPurchaseOrderData(
            languageCode: params.languageCode,
            body: body,
          );

          await pendingPurchaseOrderLocalDataSource
              .savePendingPurchaseOrder(pendingPurchaseOrder);
          print(
              '✅ Purchase order saved offline, will sync when back online (ID: ${pendingPurchaseOrder.id})');

          // Create a temporary purchase order entity for offline purchase order
          // This allows the UI to show success even when offline
          // Get supplier name from body (stored when creating offline order)
          final supplierName =
              body['supplierName'] as String? ?? 'Unknown Supplier';

          final offlinePurchaseOrder = PurchaseOrderEntity(
            id: pendingPurchaseOrder.id,
            supplierId: body['supplierId'] ?? 0,
            supplierName: supplierName, // Use stored supplier name
            currency: body['currency'] ?? 'SYP',
            total: _calculateTotal(body['items'] ?? []),
            status: 'PENDING',
            createdAt: _getCurrentDateTimeArray(),
            items: [], // Items will be populated on sync
          );

          return Right(offlinePurchaseOrder);
        } catch (e, stackTrace) {
          print('❌ Error saving purchase order offline: $e');
          print('❌ Stack trace: $stackTrace');
          return Left(Failure(
            errMessage: 'Failed to save purchase order offline: $e',
          ));
        }
      }
    } catch (e, stackTrace) {
      print('❌ Critical error in postAddPurchaseOrder: $e');
      print('❌ Stack trace: $stackTrace');
      return Left(Failure(
        errMessage: 'Unexpected error: $e',
      ));
    }
  }

  /// Calculate total from items
  double _calculateTotal(List<dynamic> items) {
    return items.fold<double>(
      0.0,
      (sum, item) => sum + ((item['quantity'] ?? 0) * (item['price'] ?? 0.0)),
    );
  }

  /// Get current date time as array [year, month, day, hour, minute, second]
  List<int> _getCurrentDateTimeArray() {
    final now = DateTime.now();
    return [
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
    ];
  }

  /// Sync pending purchase orders when back online
  @override
  Future<Either<Failure, List<PurchaseOrderEntity>>>
      syncPendingPurchaseOrders() async {
    print('🔄 syncPendingPurchaseOrders() called');

    final isConnected = await networkInfo.isConnected;
    print('📡 Network connected: $isConnected');

    if (!isConnected) {
      print('❌ No internet connection, cannot sync');
      return Left(Failure(
        errMessage:
            'No internet connection. Cannot sync pending purchase orders.'.tr,
      ));
    }

    try {
      print('📦 Getting pending purchase orders from local data source...');
      final pendingPurchaseOrders =
          pendingPurchaseOrderLocalDataSource.getPendingPurchaseOrders();
      print(
          '📦 Found ${pendingPurchaseOrders.length} pending purchase orders to sync');

      if (pendingPurchaseOrders.isEmpty) {
        return Right([]);
      }

      final syncedPurchaseOrders = <PurchaseOrderEntity>[];
      final failedPurchaseOrders = <HivePendingPurchaseOrderModel>[];

      for (final pendingPurchaseOrder in pendingPurchaseOrders) {
        try {
          print('🔄 Syncing pending order ID: ${pendingPurchaseOrder.id}');
          print('📤 Original request body: ${pendingPurchaseOrder.body}');

          // Remove fields that are only for local use (not expected by server)
          final cleanedBody =
              _cleanRequestBodyForServer(pendingPurchaseOrder.body);
          print('📤 Cleaned request body for server: $cleanedBody');

          final params = LanguageParam(
            languageCode: pendingPurchaseOrder.languageCode,
            key: 'language',
          );

          print('🌐 Sending POST request to server...');
          // Create purchase order on server
          final remotePurchaseOrder =
              await remoteDataSource.postAddPurchaseOrder(
            params,
            cleanedBody,
          );
          print('✅ Server response received: ID ${remotePurchaseOrder.id}');

          // Cache the synced purchase order
          await localDataSource.cachePurchaseOrder(remotePurchaseOrder);
          print('✅ Cached synced purchase order: ID ${remotePurchaseOrder.id}');

          // Remove pending purchase order after successful sync
          await pendingPurchaseOrderLocalDataSource
              .deletePendingPurchaseOrder(pendingPurchaseOrder.id);
          print(
              '✅ Deleted pending purchase order: ID ${pendingPurchaseOrder.id}');

          syncedPurchaseOrders.add(remotePurchaseOrder);
          print(
              '✅ Successfully synced pending purchase order (Old ID: ${pendingPurchaseOrder.id}, New ID: ${remotePurchaseOrder.id})');
        } on ConflictException catch (e) {
          // If conflict, remove pending and use server version
          await pendingPurchaseOrderLocalDataSource
              .deletePendingPurchaseOrder(pendingPurchaseOrder.id);
          print(
              '⚠️ Conflict resolved: Removed pending purchase order (ID: ${pendingPurchaseOrder.id}). Error: $e');
        } on ServerException catch (e) {
          failedPurchaseOrders.add(pendingPurchaseOrder);
          print(
              '❌ Server error syncing pending purchase order (ID: ${pendingPurchaseOrder.id}): ${e.errorModel.errorMessage}');
          print('❌ Status code: ${e.errorModel.status}');
        } catch (e, stackTrace) {
          failedPurchaseOrders.add(pendingPurchaseOrder);
          print(
              '❌ Failed to sync pending purchase order (ID: ${pendingPurchaseOrder.id}): $e');
          print('❌ Error type: ${e.runtimeType}');
          print('❌ Stack trace: $stackTrace');
        }
      }

      // Check remaining pending orders after sync
      final remainingPending =
          pendingPurchaseOrderLocalDataSource.getPendingPurchaseOrdersCount();
      print(
          '📊 After sync: ${syncedPurchaseOrders.length} synced, ${failedPurchaseOrders.length} failed, $remainingPending remaining pending');

      // Log details of failed orders
      if (failedPurchaseOrders.isNotEmpty) {
        print('❌ Failed orders details:');
        for (final failedOrder in failedPurchaseOrders) {
          print(
              '   - ID: ${failedOrder.id}, Created: ${failedOrder.createdAt}');
        }
      }

      // Even if some failed, return the successfully synced orders
      // The failed ones will remain in pending box for retry
      if (syncedPurchaseOrders.isNotEmpty) {
        if (failedPurchaseOrders.isNotEmpty) {
          print(
              '⚠️ Partial sync: ${syncedPurchaseOrders.length} synced, ${failedPurchaseOrders.length} failed');
          // Return success with synced orders, but log the failures
          return Right(syncedPurchaseOrders);
        } else {
          print('✅ All pending orders synced successfully');
          return Right(syncedPurchaseOrders);
        }
      } else {
        // All failed
        if (failedPurchaseOrders.isNotEmpty) {
          return Left(Failure(
            errMessage:
                'Failed to sync ${failedPurchaseOrders.length} purchase order(s). Please check your connection and try again.'
                    .tr,
          ));
        }
        return Right([]);
      }
    } catch (e, stackTrace) {
      print('❌ Critical error in syncPendingPurchaseOrders: $e');
      print('❌ Error type: ${e.runtimeType}');
      print('❌ Stack trace: $stackTrace');
      return Left(Failure(
        errMessage: 'Error syncing pending purchase orders: $e',
      ));
    }
  }

  /// Clean request body by removing fields that are only for local use
  /// Server only expects: supplierId, currency, items (with productId, quantity, price, productType)
  Map<String, dynamic> _cleanRequestBodyForServer(Map<String, dynamic> body) {
    final cleanedBody = <String, dynamic>{
      'supplierId': body['supplierId'],
      'currency': body['currency'],
    };

    // Clean items - only keep fields expected by server
    if (body['items'] != null) {
      final items = body['items'] as List;
      cleanedBody['items'] = items.map((item) {
        return {
          'productId': item['productId'],
          'quantity': item['quantity'],
          'price': item['price'],
          'productType': item['productType'],
        };
      }).toList();
    }

    return cleanedBody;
  }
}
