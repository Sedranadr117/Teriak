import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/products/all_products/data/datasources/product_remote_data_source.dart';
import 'package:teriak/features/products/all_products/data/datasources/product_local_data_source.dart';
import 'package:teriak/features/products/all_products/data/models/hive_product_model.dart';
import 'package:teriak/features/products/all_products/data/repositories/product_repository_impl.dart';
import 'package:teriak/features/products/all_products/domain/entities/product_entity.dart';
import 'package:teriak/features/products/all_products/domain/usecases/get_product.dart';
import 'package:teriak/features/products/add_product/data/models/hive_pending_product_model.dart';
import 'package:teriak/features/products/add_product/data/datasources/add_product_local_data_source.dart';
import 'package:teriak/features/products/add_product/data/datasources/add_product_remote_data_source.dart';
import 'package:teriak/features/products/add_product/data/repositories/add_product_repository_impl.dart';

class GetAllProductController extends GetxController {
  late final NetworkInfoImpl networkInfo;
  late final GetAllProduct getAllProductUseCase;

  var isLoading = true.obs;
  var products = <ProductEntity>[].obs;
  var errorMessage = ''.obs;
  var isRefreshing = false.obs;

  // Pagination variables
  var currentPage = 0.obs;
  var pageSize = 10.obs;
  var totalPages = 0.obs;
  var totalElements = 0.obs;
  var hasNext = false.obs;
  var hasPrevious = false.obs;
  var isLoadingMore = false.obs;

  // Sync status
  var isSyncing = false.obs;
  var pendingProductsCount = 0.obs;
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

    final remoteDataSource = ProductRemoteDataSource(api: httpConsumer);
    final productBox = Hive.box<HiveProductModel>('productCache');
    final localDataSource = ProductLocalDataSourceImpl(productBox: productBox);

    final repository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );

    getAllProductUseCase = GetAllProduct(repository: repository);
    // Clean up any existing duplicates in cache on initialization
    localDataSource.clearDuplicateProducts().then((_) {
      print('🧹 Cache cleanup completed');
    }).catchError((e) {
      print('⚠️ Cache cleanup error: $e');
    });
    getProducts();
    _checkAndSyncPendingProducts();
    _updatePendingProductsCount();
  }

  /// Update pending products count (public method for external updates)
  void updatePendingProductsCount() {
    _updatePendingProductsCount();
  }

  /// Update pending products count
  void _updatePendingProductsCount() {
    try {
      final pendingProductBox =
          Hive.box<HivePendingProductModel>('pendingProducts');
      pendingProductsCount.value = pendingProductBox.length;
    } catch (e) {
      print('⚠️ Could not get pending products count: $e');
    }
  }

  /// Manually sync pending products
  Future<void> manualSyncPendingProducts() async {
    if (isSyncing.value) return;

    try {
      isSyncing.value = true;
      syncStatusMessage.value = 'Checking connection...'.tr;

      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        syncStatusMessage.value = 'No internet connection'.tr;
        Get.snackbar('Sync Error'.tr, 'No internet connection'.tr);
        return;
      }

      // Check pending products
      final pendingProductBox =
          Hive.box<HivePendingProductModel>('pendingProducts');
      final pendingCount = pendingProductBox.length;

      if (pendingCount == 0) {
        syncStatusMessage.value = 'No pending products to sync'.tr;
        Get.snackbar('Sync'.tr, 'No pending products to sync.'.tr);
        return;
      }

      syncStatusMessage.value = 'Syncing $pendingCount product(s)...'.tr;

      // Create repository to sync
      final cacheHelper = CacheHelper();
      final httpConsumer = HttpConsumer(
        baseUrl: EndPoints.baserUrl,
        cacheHelper: cacheHelper,
      );
      final remoteDataSource = AddProductRemoteDataSource(api: httpConsumer);
      final productBox = Hive.box<HiveProductModel>('productCache');
      final localDataSource =
          ProductLocalDataSourceImpl(productBox: productBox);
      final pendingProductLocalDataSource = AddProductLocalDataSourceImpl(
        pendingProductBox: pendingProductBox,
      );

      final addProductRepository = AddProductRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
        pendingProductLocalDataSource: pendingProductLocalDataSource,
        networkInfo: networkInfo,
      );

      final syncResult = await addProductRepository.syncPendingProducts();
      syncResult.fold(
        (failure) {
          syncStatusMessage.value = 'Sync failed: ${failure.errMessage}'.tr;
          Get.snackbar('Sync Error'.tr, failure.errMessage);
        },
        (syncedProducts) {
          if (syncedProducts.isEmpty) {
            syncStatusMessage.value = 'No products synced'.tr;
            Get.snackbar('Sync'.tr, 'No pending products to sync.'.tr);
          } else {
            syncStatusMessage.value =
                'Successfully synced ${syncedProducts.length} product(s)'.tr;
            Get.snackbar(
              'Sync Success'.tr,
              'Synced ${syncedProducts.length} product(s) successfully.'.tr,
            );
            // Refresh products list after successful sync
            Future.delayed(const Duration(milliseconds: 500), () {
              refreshProducts(skipCache: true);
            });
          }
          _updatePendingProductsCount();
        },
      );
    } catch (e) {
      syncStatusMessage.value = 'Sync error: $e'.tr;
      Get.snackbar('Sync Error'.tr, 'Failed to sync products: $e');
    } finally {
      isSyncing.value = false;
      // Clear status message after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (syncStatusMessage.value.isNotEmpty) {
          syncStatusMessage.value = '';
        }
      });
    }
  }

  /// Check for pending products and sync them if online
  Future<void> _checkAndSyncPendingProducts() async {
    try {
      // Check if there are pending products and we're online
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return;
      }

      // Check pending products directly from Hive box
      try {
        final pendingProductBox =
            Hive.box<HivePendingProductModel>('pendingProducts');
        final pendingCount = pendingProductBox.length;

        if (pendingCount > 0) {
          print(
              '📦 Found $pendingCount pending product(s) while loading products. Syncing...');

          // Create repository to sync
          final cacheHelper = CacheHelper();
          final httpConsumer = HttpConsumer(
            baseUrl: EndPoints.baserUrl,
            cacheHelper: cacheHelper,
          );
          final remoteDataSource =
              AddProductRemoteDataSource(api: httpConsumer);
          final productBox = Hive.box<HiveProductModel>('productCache');
          final localDataSource =
              ProductLocalDataSourceImpl(productBox: productBox);
          final pendingProductLocalDataSource = AddProductLocalDataSourceImpl(
            pendingProductBox: pendingProductBox,
          );

          final addProductRepository = AddProductRepositoryImpl(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource,
            pendingProductLocalDataSource: pendingProductLocalDataSource,
            networkInfo: networkInfo,
          );

          final syncResult = await addProductRepository.syncPendingProducts();
          syncResult.fold(
            (failure) {
              print('⚠️ Auto-sync failed: ${failure.errMessage}');
              syncStatusMessage.value =
                  'Auto-sync failed: ${failure.errMessage}'.tr;
            },
            (syncedProducts) {
              if (syncedProducts.isNotEmpty) {
                print(
                    '✅ Auto-synced ${syncedProducts.length} pending product(s)');
                syncStatusMessage.value =
                    'Auto-synced ${syncedProducts.length} product(s)'.tr;
                // Refresh products list after sync
                Future.delayed(const Duration(milliseconds: 500), () {
                  refreshProducts();
                });
              }
              _updatePendingProductsCount();
            },
          );
        }
      } catch (e) {
        print('ℹ️ Could not check pending products: $e');
      }
    } catch (e) {
      print('ℹ️ Could not check pending products: $e');
    }
  }

  void getProducts({bool refresh = false, bool skipCache = false}) async {
    try {
      if (refresh) {
        currentPage.value = 0;
        isLoading.value = true;
        products.clear();
      } else {
        isLoading.value = true;
      }

      String currentLanguageCode = LocaleController.to.locale.languageCode;
      final params = AllProductParams(
        languageCode: currentLanguageCode,
        page: currentPage.value,
        size: pageSize.value,
      );

      final result =
          await getAllProductUseCase(params: params, skipCache: skipCache);
      result.fold(
        (failure) {
          if (failure.statusCode == 401) {
            Get.snackbar('Error'.tr, "login cancel".tr);
          } else {
            errorMessage.value = failure.errMessage;
          }
        },
        (paginatedData) {
          // First, deduplicate the API response itself
          final seenKeys = <String>{};
          final deduplicatedContent = <ProductEntity>[];

          for (var product in paginatedData.content) {
            final key = '${product.id}_${product.productType}';
            if (!seenKeys.contains(key)) {
              seenKeys.add(key);
              deduplicatedContent.add(product);
            } else {
              print(
                  '⚠️ Skipping duplicate in API response: ID=${product.id}, Type=${product.productType}');
            }
          }

          // Then check against existing products in the list
          final newProducts = <ProductEntity>[];
          for (var product in deduplicatedContent) {
            bool exists = products.any((p) =>
                p.id == product.id && p.productType == product.productType);
            print('📊 product.barcode: ${product.barcode}');

            if (!exists) {
              newProducts.add(product);
            }
          }

          if (refresh) {
            products.value = newProducts;
          } else {
            products.addAll(newProducts);
          }

          totalPages.value = paginatedData.totalPages;
          totalElements.value = paginatedData.totalElements;
          hasNext.value = paginatedData.hasNext;
          hasPrevious.value = paginatedData.hasPrevious;

          print(
              '📊 Products list: ${products.length} products (${deduplicatedContent.length} from API, ${newProducts.length} new)');
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
        currentPage.value++;

        String currentLanguageCode = LocaleController.to.locale.languageCode;
        final params = AllProductParams(
          languageCode: currentLanguageCode,
          page: currentPage.value,
          size: pageSize.value,
        );

        final result = await getAllProductUseCase(params: params);
        result.fold(
          (failure) {
            if (failure.statusCode == 401) {
              errorMessage.value = '';
              Get.snackbar('Error'.tr, "login cancel".tr);
            } else {
              errorMessage.value = failure.errMessage;
            }
          },
          (paginatedData) {
            // First, deduplicate the API response itself
            final seenKeys = <String>{};
            final deduplicatedContent = <ProductEntity>[];

            for (var product in paginatedData.content) {
              final key = '${product.id}_${product.productType}';
              if (!seenKeys.contains(key)) {
                seenKeys.add(key);
                deduplicatedContent.add(product);
              } else {
                print(
                    '⚠️ Skipping duplicate in API response: ID=${product.id}, Type=${product.productType}');
              }
            }

            // Then check against existing products in the list
            final newProducts = <ProductEntity>[];
            for (var product in deduplicatedContent) {
              bool exists = products.any((p) =>
                  p.id == product.id && p.productType == product.productType);
              if (!exists) {
                newProducts.add(product);
              }
            }
            products.addAll(newProducts);

            totalPages.value = paginatedData.totalPages;
            totalElements.value = paginatedData.totalElements;
            hasNext.value = paginatedData.hasNext;
            hasPrevious.value = paginatedData.hasPrevious;

            print(
                '📊 Loaded more: ${newProducts.length} new products (${deduplicatedContent.length} from API)');
          },
        );
      } catch (e) {
        errorMessage.value =
            'An unexpected error occurred. Please try again.'.tr;
        Get.snackbar(
          'Error'.tr,
          errorMessage.value,
        );
      } finally {
        isLoadingMore.value = false;
      }
    }
  }

  Future<void> refreshProducts({bool skipCache = true}) async {
    try {
      isRefreshing.value = true;
      await Future.delayed(const Duration(milliseconds: 1500));

      // Check if we're online
      final isConnected = await networkInfo.isConnected;

      // If offline, always use cached data (don't skip cache)
      final shouldSkipCache = isConnected ? skipCache : false;

      // Only clean up duplicates if we're online and not skipping cache
      // If offline, we should preserve all cached products
      if (isConnected && !shouldSkipCache) {
        final productBox = Hive.box<HiveProductModel>('productCache');
        final localDataSource =
            ProductLocalDataSourceImpl(productBox: productBox);
        print('🧹 Cleaning duplicates before refresh (online, using cache)');
        await localDataSource.clearDuplicateProducts();
      } else if (!isConnected) {
        print('📦 Offline refresh: Using cached data without cleanup');
      }

      getProducts(refresh: true, skipCache: shouldSkipCache);
    } finally {
      isRefreshing.value = false;
    }
  }
}
