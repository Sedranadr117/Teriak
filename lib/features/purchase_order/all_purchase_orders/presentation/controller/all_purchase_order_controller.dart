import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/data/datasources/add_purchase_local_data_source.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/data/datasources/add_purchase_remote_data_source.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/data/repositories/add_purchase_repository_impl.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/datasources/all_purchase_remote_data_source.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/datasources/purchase_order_local_data_source.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/hive_purchase_order_model.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/repositories/all_purchase_repository_impl.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/purchase_entity%20.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/product_item_entity.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/usecases/get_all_purchase.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/data/models/hive_pending_purchase_order_model.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/controller/all_supplier_controller.dart';
import 'package:teriak/features/products/all_products/presentation/controller/get_allProduct_controller.dart';

class GetAllPurchaseOrderController extends GetxController {
  late final NetworkInfoImpl networkInfo;
  late final GetAllPurchaseOrders getAllPurchaseUseCase;
  late final PurchaseOrderLocalDataSource localDataSource;
  late final AddPurchaseOrderRepositoryImpl addPurchaseOrderRepository;
  var isLoading = true.obs;
  var purchaseOrders = <PurchaseOrderEntity>[].obs;
  var errorMessage = ''.obs;
  var isRefreshing = false.obs;

  // Pagination variables
  var currentPage = 0.obs;
  var pageSize = 5.obs;
  var totalPages = 0.obs;
  var totalElements = 0.obs;
  var hasNext = false.obs;
  var hasPrevious = false.obs;
  var isLoadingMore = false.obs;

  var pendingPurchaseOrders = <PurchaseOrderEntity>[].obs;
  var isLoadingPendingOrders = false.obs;
  var errorMessagePendingOrders = ''.obs;

  // Sync status
  var isSyncing = false.obs;
  var syncStatusMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    networkInfo = NetworkInfoImpl();

    final remoteDataSource =
        AllPurchaseOrdersRemoteDataSource(api: httpConsumer);

    // Get Hive box for purchase orders
    final purchaseOrderBox =
        Hive.box<HivePurchaseOrderModel>('purchaseOrderCache');
    localDataSource =
        PurchaseOrderLocalDataSourceImpl(purchaseOrderBox: purchaseOrderBox);

    final repository = AllPurchaseOrdersRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
      localDataSource: localDataSource,
    );

    getAllPurchaseUseCase = GetAllPurchaseOrders(repository: repository);

    // Initialize add purchase order repository for syncing
    _initializeAddPurchaseOrderRepository();

    // Clean up any duplicates in cache on initialization
    localDataSource.clearDuplicatePurchaseOrders().then((_) {
      print('🧹 Purchase order cache cleanup completed');
    }).catchError((e) {
      print('⚠️ Purchase order cache cleanup error: $e');
    });

    getPurchaseOrders();
    getAllPendingPurchaseOrders();
  }

  void _initializeAddPurchaseOrderRepository() {
    final cacheHelper = CacheHelper();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    final addPurchaseRemoteDataSource =
        AddPurchaseOrderRemoteDataSource(api: httpConsumer);

    final pendingPurchaseOrderBox =
        Hive.box<HivePendingPurchaseOrderModel>('pendingPurchaseOrders');
    final pendingPurchaseOrderLocalDataSource =
        AddPurchaseOrderLocalDataSourceImpl(
            pendingPurchaseOrderBox: pendingPurchaseOrderBox);

    addPurchaseOrderRepository = AddPurchaseOrderRepositoryImpl(
      remoteDataSource: addPurchaseRemoteDataSource,
      networkInfo: networkInfo,
      localDataSource: localDataSource,
      pendingPurchaseOrderLocalDataSource: pendingPurchaseOrderLocalDataSource,
    );
    print('✅ AddPurchaseOrderRepository initialized');
  }

  bool _isRepositoryInitialized() {
    // Use a flag or check if the field has been set
    // Since we can't safely check late final fields, we'll use a different approach
    // We'll just try to initialize it if needed - it's safe to call multiple times
    return true; // Always return true and let initialization handle it
  }

  void getPurchaseOrders({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 0;
        isLoading.value = true;
      } else {
        isLoading.value = true;
      }

      String currentLanguageCode = LocaleController.to.locale.languageCode;
      final params = PaginationParams(
        page: currentPage.value,
        size: pageSize.value,
        languageCode: currentLanguageCode,
      );

      final result = await getAllPurchaseUseCase(params: params);
      result.fold(
        (failure) {
          // Only show error if we don't have cached data
          // Check if we have any cached data to show
          final cachedData = localDataSource.getCachedPurchaseOrdersPaginated(
            page: params.page,
            size: params.size,
          );

          if (cachedData.content.isNotEmpty) {
            // We have cached data, show it and clear error
            // Remove duplicates from cached data
            final uniqueItems = <PurchaseOrderEntity>[];
            final seenIds = <int>{};

            for (final item in cachedData.content) {
              if (!seenIds.contains(item.id)) {
                uniqueItems.add(item);
                seenIds.add(item.id);
              }
            }

            purchaseOrders.value = uniqueItems;
            totalPages.value = cachedData.totalPages;
            totalElements.value = cachedData.totalElements;
            hasNext.value = cachedData.hasNext;
            hasPrevious.value = cachedData.hasPrevious;
            errorMessage.value = ''; // Clear error since we have cached data
            print(
                '📦 Showing ${cachedData.content.length} cached purchase orders despite error');
          } else {
            // No cached data, show error
            if (failure.statusCode == 401) {
              Get.snackbar('Error'.tr, "login cancel".tr);
            } else {
              errorMessage.value = failure.errMessage;
            }
          }
        },
        (paginatedData) {
          // Success - clear any previous errors
          errorMessage.value = '';

          // Always replace the list on refresh to show latest data
          // On pagination, append new items
          if (refresh || currentPage.value == 0) {
            // Merge with existing list instead of replacing completely
            // This preserves items that might be on other pages
            final existingIds = purchaseOrders.map((e) => e.id).toSet();
            final newItems = <PurchaseOrderEntity>[];
            final updatedItems = <PurchaseOrderEntity>[];

            for (final item in paginatedData.content) {
              if (!existingIds.contains(item.id)) {
                // New item - add to beginning
                newItems.add(item);
              } else {
                // Existing item - update it (might have changed on server)
                final existingIndex =
                    purchaseOrders.indexWhere((e) => e.id == item.id);
                if (existingIndex != -1) {
                  purchaseOrders[existingIndex] = item;
                  updatedItems.add(item);
                }
              }
            }

            // Add new items at the beginning (newest first)
            if (newItems.isNotEmpty) {
              purchaseOrders.insertAll(0, newItems);
              print('✅ Refresh: Added ${newItems.length} new purchase orders');
            }

            if (updatedItems.isNotEmpty) {
              print(
                  '✅ Refresh: Updated ${updatedItems.length} existing purchase orders');
            }

            // If no new items and we're refreshing, we might want to keep existing items
            // but update the ones we got from server
            if (newItems.isEmpty &&
                updatedItems.isEmpty &&
                purchaseOrders.length > paginatedData.content.length) {
              // We have more items in the list than what we got from server
              // This is normal for pagination - we keep the existing items
              print(
                  '📊 Refresh: Keeping ${purchaseOrders.length} items (${paginatedData.content.length} from server)');
            }

            print(
                '✅ Refreshed purchase orders list: ${purchaseOrders.length} total items (${newItems.length} new, ${updatedItems.length} updated)');
          } else {
            // For pagination, check for duplicates before adding
            final existingIds = purchaseOrders.map((e) => e.id).toSet();
            final newItems = paginatedData.content
                .where((item) => !existingIds.contains(item.id))
                .toList();

            if (newItems.isNotEmpty) {
              purchaseOrders.addAll(newItems);
              print(
                  '✅ Added ${newItems.length} new purchase orders (${paginatedData.content.length - newItems.length} duplicates skipped)');
            } else {
              print(
                  '⚠️ All ${paginatedData.content.length} items from page ${currentPage.value} are duplicates, skipping');
            }
          }

          // Update pagination info, but include offline orders in total
          final pendingBox =
              Hive.box<HivePendingPurchaseOrderModel>('pendingPurchaseOrders');
          final pendingCount = pendingBox.length;

          totalPages.value = paginatedData.totalPages;
          // Include pending offline orders in total count
          totalElements.value = paginatedData.totalElements + pendingCount;
          hasNext.value = paginatedData.hasNext || pendingCount > 0;
          hasPrevious.value = paginatedData.hasPrevious;

          print(
              '📊 Total: ${paginatedData.totalElements} from server + $pendingCount pending = ${totalElements.value} total');
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred. Please try again.'.tr;
      Get.snackbar(
        'Error'.tr,
        errorMessage.value,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadNextPage() async {
    if (hasNext.value && !isLoadingMore.value) {
      try {
        isLoadingMore.value = true;
        print('📄 Loading next page: ${currentPage.value + 1}');
        currentPage.value++;

        String currentLanguageCode = LocaleController.to.locale.languageCode;
        final params = PaginationParams(
          page: currentPage.value,
          size: pageSize.value,
          languageCode: currentLanguageCode,
        );

        print('📤 Requesting page ${params.page} with size ${params.size}');
        final result = await getAllPurchaseUseCase(params: params);
        result.fold(
          (failure) {
            if (failure.statusCode == 401) {
              Get.snackbar('Error'.tr, "login cancel".tr);
            } else {
              errorMessage.value = failure.errMessage;
            }
          },
          (paginatedData) {
            // Check for duplicates before adding
            final existingIds = purchaseOrders.map((e) => e.id).toSet();
            final newItems = paginatedData.content
                .where((item) => !existingIds.contains(item.id))
                .toList();

            if (newItems.isNotEmpty) {
              purchaseOrders.addAll(newItems);
              print(
                  '✅ Added ${newItems.length} new purchase orders (${paginatedData.content.length - newItems.length} duplicates skipped)');
              print('📊 Total items now: ${purchaseOrders.length}');
            } else {
              print(
                  '⚠️ All ${paginatedData.content.length} items from page ${currentPage.value} are duplicates, skipping');
            }

            // Update pagination info, but include offline orders in total
            final pendingBox = Hive.box<HivePendingPurchaseOrderModel>(
                'pendingPurchaseOrders');
            final pendingCount = pendingBox.length;

            // Include pending offline orders in total count
            totalElements.value = paginatedData.totalElements + pendingCount;
            // Recalculate totalPages based on totalElements (not just server pages)
            totalPages.value = (totalElements.value / pageSize.value).ceil();
            hasNext.value = purchaseOrders.length < totalElements.value ||
                paginatedData.hasNext;
            hasPrevious.value = currentPage.value > 0;

            print(
                '📊 Pagination: Page ${currentPage.value}/${totalPages.value}, Total: ${totalElements.value} (${paginatedData.totalElements} server + $pendingCount pending), HasNext: ${hasNext.value}');
          },
        );
      } catch (e) {
        print('❌ Error loading next page: $e');
        errorMessage.value =
            'An unexpected error occurred. Please try again.'.tr;
        Get.snackbar(
          'Error'.tr,
          errorMessage.value,
        );
      } finally {
        isLoadingMore.value = false;
      }
    } else {
      print(
          '⚠️ Cannot load next page: hasNext=${hasNext.value}, isLoadingMore=${isLoadingMore.value}');
    }
  }

  Future<void> getAllPendingPurchaseOrders() async {
    try {
      isLoadingPendingOrders.value = true;
      errorMessagePendingOrders.value = '';

      String currentLanguageCode = LocaleController.to.locale.languageCode;

      final params = PaginationParams(
        page: 0,
        size: 1000,
        languageCode: currentLanguageCode,
      );

      final result = await getAllPurchaseUseCase(params: params);
      result.fold(
        (failure) {
          if (failure.statusCode == 401) {
            Get.snackbar('Error'.tr, "login cancel".tr);
          } else {
            errorMessage.value = failure.errMessage;
          }
        },
        (paginatedData) {
          final allPendingOrders = paginatedData.content
              .where((order) => order.status == 'PENDING')
              .toList();
          pendingPurchaseOrders.value = allPendingOrders;
        },
      );
    } catch (e) {
      errorMessagePendingOrders.value =
          'An unexpected error occurred. Please try again.'.tr;

      Get.snackbar(
        'Error'.tr,
        errorMessagePendingOrders.value,
      );
    } finally {
      isLoadingPendingOrders.value = false;
    }
  }

  Future<void> refreshPurchaseOrders() async {
    try {
      isRefreshing.value = true;
      // Reset to first page to show newest orders (including the one just created)
      currentPage.value = 0;
      // Small delay to ensure cache is written
      await Future.delayed(const Duration(milliseconds: 500));

      // First, check for pending offline orders and add them to the list
      final pendingBox =
          Hive.box<HivePendingPurchaseOrderModel>('pendingPurchaseOrders');
      final pendingOrders = pendingBox.values.toList();
      final existingIds = purchaseOrders.map((e) => e.id).toSet();

      for (final pendingOrder in pendingOrders) {
        // Convert pending order to entity and add to list if not already there
        if (!existingIds.contains(pendingOrder.id)) {
          // Get supplier name from body (stored when creating offline order)
          final supplierId = pendingOrder.body['supplierId'] ?? 0;
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
          purchaseOrders.insert(0, offlineOrder);
          existingIds.add(offlineOrder.id);
          print(
              '✅ Added pending offline order to list: ID ${offlineOrder.id}, Supplier: $supplierName');
        }
      }

      // Also check cache for newly created orders
      final allCachedOrders = localDataSource.getCachedPurchaseOrders();
      if (allCachedOrders.isNotEmpty) {
        // Get the most recent order (should be the newly created one)
        final mostRecentOrder = allCachedOrders.first;
        if (!existingIds.contains(mostRecentOrder.id)) {
          print(
              '✅ Adding new order from cache to list: ID ${mostRecentOrder.id}');
          purchaseOrders.insert(0, mostRecentOrder);
          totalElements.value = totalElements.value + 1;
        }
      }

      getPurchaseOrders(refresh: true);
    } finally {
      isRefreshing.value = false;
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

  /// Add a newly created purchase order to the list immediately
  void addNewPurchaseOrder(PurchaseOrderEntity purchaseOrder) {
    final existingIds = purchaseOrders.map((e) => e.id).toSet();
    if (!existingIds.contains(purchaseOrder.id)) {
      print(
          '✅ Adding new purchase order to list immediately: ID ${purchaseOrder.id}');
      purchaseOrders.insert(
          0, purchaseOrder); // Add at the beginning (newest first)
      totalElements.value = totalElements.value + 1;
      // Recalculate total pages
      totalPages.value = (totalElements.value / pageSize.value).ceil();
      hasNext.value = purchaseOrders.length < totalElements.value;
    } else {
      print('⚠️ Purchase order ${purchaseOrder.id} already exists in list');
    }
  }

  /// Manually sync purchase orders from server
  Future<void> manualSyncPurchaseOrders() async {
    if (isSyncing.value) return;

    try {
      isSyncing.value = true;
      syncStatusMessage.value = 'Syncing purchase orders...'.tr;

      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        syncStatusMessage.value = 'No internet connection'.tr;
        Get.snackbar('Sync Error'.tr, 'No internet connection'.tr);
        await Future.delayed(const Duration(seconds: 2));
        syncStatusMessage.value = '';
        return;
      }

      // Force refresh from server
      String currentLanguageCode = LocaleController.to.locale.languageCode;
      final params = PaginationParams(
        page: 0,
        size: pageSize.value,
        languageCode: currentLanguageCode,
      );

      // First, sync any pending offline purchase orders
      syncStatusMessage.value = 'Syncing pending offline orders...'.tr;

      // Check pending orders count before sync
      final pendingBoxBeforeSync =
          Hive.box<HivePendingPurchaseOrderModel>('pendingPurchaseOrders');
      final pendingCountBeforeSync = pendingBoxBeforeSync.length;
      print('🔄 Starting sync: Found $pendingCountBeforeSync pending orders');

      try {
        // Ensure repository is initialized (safe to call multiple times)
        try {
          // Try to access - if it fails, initialize it
          final _ = addPurchaseOrderRepository;
        } catch (e) {
          print('⚠️ Repository not initialized, initializing now...');
          _initializeAddPurchaseOrderRepository();
        }

        print('🔄 Calling syncPendingPurchaseOrders()...');
        final syncResult =
            await addPurchaseOrderRepository.syncPendingPurchaseOrders();
        print('🔄 syncPendingPurchaseOrders() completed');
        syncResult.fold(
          (failure) {
            syncStatusMessage.value =
                'Pending sync failed: ${failure.errMessage}'.tr;
            Get.snackbar('Sync Error'.tr, failure.errMessage);
            print('❌ Failed to sync pending orders: ${failure.errMessage}');
            print('❌ Status code: ${failure.statusCode}');
          },
          (syncedOrders) {
            if (syncedOrders.isNotEmpty) {
              syncStatusMessage.value =
                  '${syncedOrders.length} pending order(s) synced'.tr;
              print('✅ Synced ${syncedOrders.length} pending orders');

              // Add synced orders to the list
              final existingIds = purchaseOrders.map((e) => e.id).toSet();
              for (final syncedOrder in syncedOrders) {
                if (!existingIds.contains(syncedOrder.id)) {
                  purchaseOrders.insert(0, syncedOrder);
                  existingIds.add(syncedOrder.id);
                  print('✅ Added synced order to list: ID ${syncedOrder.id}');
                } else {
                  print(
                      '⚠️ Synced order already in list: ID ${syncedOrder.id}');
                }
              }

              // Pending orders are now removed from pending box after sync
              print('✅ Pending orders removed from pending box after sync');

              // Verify pending count after sync
              final pendingBoxCheck = Hive.box<HivePendingPurchaseOrderModel>(
                  'pendingPurchaseOrders');
              final remainingPending = pendingBoxCheck.length;
              print(
                  '📊 Remaining pending orders after sync: $remainingPending');

              if (remainingPending > 0) {
                print(
                    '⚠️ Warning: $remainingPending pending orders still remain. They may have failed to sync.');
              }
            } else {
              syncStatusMessage.value = 'No pending offline orders to sync'.tr;
              print('ℹ️ No pending orders to sync');

              // Check if there are actually pending orders
              final pendingBoxCheck = Hive.box<HivePendingPurchaseOrderModel>(
                  'pendingPurchaseOrders');
              final pendingCount = pendingBoxCheck.length;
              if (pendingCount > 0) {
                print(
                    '⚠️ Warning: Found $pendingCount pending orders but sync returned empty. They may have failed to sync.');
              }
            }
          },
        );
      } catch (e, stackTrace) {
        print('❌ Critical error in manual sync (pending orders): $e');
        print('❌ Error type: ${e.runtimeType}');
        print('❌ Stack trace: $stackTrace');
        syncStatusMessage.value = 'Error syncing pending orders: $e'.tr;
        // Continue with sync even if pending sync fails
      }

      // Wait a moment for pending box to be updated and verify
      await Future.delayed(const Duration(milliseconds: 200));

      // Verify pending orders count after sync
      final pendingBoxAfterSync =
          Hive.box<HivePendingPurchaseOrderModel>('pendingPurchaseOrders');
      final pendingCountAfterSync = pendingBoxAfterSync.length;
      print('📊 Pending orders count after sync: $pendingCountAfterSync');

      syncStatusMessage.value = 'Fetching latest data...'.tr;
      final result = await getAllPurchaseUseCase(params: params);

      result.fold(
        (failure) {
          syncStatusMessage.value = 'Sync failed: ${failure.errMessage}'.tr;
          Get.snackbar('Sync Error'.tr, failure.errMessage);
          // Clear message after 3 seconds
          Future.delayed(const Duration(seconds: 3), () {
            syncStatusMessage.value = '';
          });
        },
        (paginatedData) {
          // Merge new items with existing list instead of replacing
          final existingIds = purchaseOrders.map((e) => e.id).toSet();
          final newItems = <PurchaseOrderEntity>[];
          final updatedItems = <PurchaseOrderEntity>[];

          for (final item in paginatedData.content) {
            if (!existingIds.contains(item.id)) {
              // New item - add to beginning
              newItems.add(item);
            } else {
              // Existing item - check if it actually changed before marking as updated
              final existingIndex =
                  purchaseOrders.indexWhere((e) => e.id == item.id);
              if (existingIndex != -1) {
                final existingItem = purchaseOrders[existingIndex];
                // Only mark as updated if data actually changed
                if (existingItem.total != item.total ||
                    existingItem.status != item.status ||
                    existingItem.supplierName != item.supplierName) {
                  purchaseOrders[existingIndex] = item;
                  updatedItems.add(item);
                } else {
                  // Data hasn't changed, just refresh the reference
                  purchaseOrders[existingIndex] = item;
                }
              }
            }
          }

          // Add new items at the beginning (newest first)
          if (newItems.isNotEmpty) {
            purchaseOrders.insertAll(0, newItems);
            print('✅ Sync: Added ${newItems.length} new purchase orders');
          }

          if (updatedItems.isNotEmpty) {
            print(
                '✅ Sync: Updated ${updatedItems.length} existing purchase orders (data changed)');
          } else if (newItems.isEmpty) {
            print('ℹ️ Sync: No new or updated orders (all data is current)');
          }

          // After sync, check for any remaining pending orders (those that failed to sync)
          final pendingBox =
              Hive.box<HivePendingPurchaseOrderModel>('pendingPurchaseOrders');
          final pendingCount = pendingBox.length;

          // After sync, all synced orders are now on the server
          // Only count remaining pending orders (if any failed to sync)
          totalElements.value = paginatedData.totalElements + pendingCount;
          // Recalculate totalPages based on totalElements (not just server pages)
          totalPages.value = (totalElements.value / pageSize.value).ceil();
          hasNext.value = purchaseOrders.length < totalElements.value ||
              paginatedData.hasNext;
          hasPrevious.value = currentPage.value > 0;
          currentPage.value = 0;
          errorMessage.value = '';

          syncStatusMessage.value = 'Sync completed successfully'.tr;
          print(
              '📊 Sync: Total items now: ${purchaseOrders.length}, Total on server: ${paginatedData.totalElements}, Remaining pending: $pendingCount, Total: ${totalElements.value}, Total pages: ${totalPages.value}');

          // Show accurate sync message
          String syncMessage = 'Sync completed'.tr;
          if (newItems.isNotEmpty && updatedItems.isNotEmpty) {
            syncMessage =
                'Added ${newItems.length} new, updated ${updatedItems.length} existing'
                    .tr;
          } else if (newItems.isNotEmpty) {
            syncMessage = 'Added ${newItems.length} new purchase order(s)'.tr;
          } else if (updatedItems.isNotEmpty) {
            syncMessage = 'Updated ${updatedItems.length} purchase order(s)'.tr;
          } else {
            syncMessage = 'Sync completed - all data is current'.tr;
          }

          Get.snackbar('Sync Success'.tr, syncMessage);

          // Clear message after 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            syncStatusMessage.value = '';
          });
        },
      );
    } catch (e) {
      syncStatusMessage.value = 'Sync error: ${e.toString()}'.tr;
      Get.snackbar('Sync Error'.tr, e.toString());
      Future.delayed(const Duration(seconds: 3), () {
        syncStatusMessage.value = '';
      });
    } finally {
      isSyncing.value = false;
    }
  }
}
