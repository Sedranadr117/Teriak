import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/products/add_product/data/datasources/add_product_local_data_source.dart';
import 'package:teriak/features/products/add_product/data/datasources/add_product_remote_data_source.dart';
import 'package:teriak/features/products/add_product/data/models/hive_pending_product_model.dart';
import 'package:teriak/features/products/add_product/data/repositories/add_product_repository_impl.dart';
import 'package:teriak/features/products/add_product/domain/usecases/post_add_product.dart';
import 'package:teriak/features/products/all_products/data/datasources/product_local_data_source.dart';
import 'package:teriak/features/products/all_products/data/models/hive_product_model.dart';
import 'package:teriak/features/products/all_products/presentation/controller/get_allProduct_controller.dart';
import 'package:teriak/features/products/product_data/data/models/product_data_model.dart';
import 'package:teriak/features/products/product_data/presentation/controller/product_data_controller.dart';

class AddProductController extends GetxController {
  final TextEditingController arabicTradeNameController =
      TextEditingController();
  final TextEditingController englishTradeNameController =
      TextEditingController();
  final TextEditingController arabicScientificNameController =
      TextEditingController();
  final TextEditingController englishScientificNameController =
      TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  //final TextEditingController minStockController = TextEditingController();

  var selectedForm = RxnString();
  var selectedManufacturer = RxnString();
  var selectedProductType = RxnString();
  var barcodes = <String>[].obs;
  var requiresPrescription = false.obs;

  // var arabicTradeNameError = RxnString();
  // var englishTradeNameError = RxnString();
  var formError = RxnString();
  var manufacturerError = RxnString();
  var quantityError = RxnString();

  var selectedFormId = 0.obs;
  var selectedManufacturerId = 0.obs;
  var selectedTypeId = 0.obs;
  var selectedCategoryIds = <int>[].obs;

  late final NetworkInfoImpl networkInfo;
  late final GetAddProduct addProductUseCase;
  late final AddProductRepositoryImpl repository;
  var isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _wasOffline = false;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    _startConnectivityMonitoring();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    arabicTradeNameController.dispose();
    englishTradeNameController.dispose();
    englishScientificNameController.dispose();
    arabicScientificNameController.dispose();
    quantityController.dispose();
    barcodeController.dispose();
    dosageController.dispose();
    notesController.dispose();
    super.onClose();
  }

  /// Start monitoring connectivity changes to auto-sync pending products
  void _startConnectivityMonitoring() async {
    // Check initial connectivity state
    final initialConnectivity = await Connectivity().checkConnectivity();
    _wasOffline = initialConnectivity.contains(ConnectivityResult.none);

    // If we're already online on app start, check for pending products to sync
    if (!_wasOffline) {
      final pendingCount = getPendingProductsCount();
      if (pendingCount > 0) {
        print('📦 Found $pendingCount pending product(s). Syncing...');
        // Delay slightly to ensure app is fully initialized
        Future.delayed(
            const Duration(seconds: 1), () => _autoSyncPendingProducts());
      }
    }

    // Listen for connectivity changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) async {
        final isNowOnline = !results.contains(ConnectivityResult.none);

        // If we were offline and now we're online, sync pending products
        if (_wasOffline && isNowOnline) {
          print('🔄 Connectivity restored! Auto-syncing pending products...');
          await _autoSyncPendingProducts();
        }

        _wasOffline = !isNowOnline;
      },
    );
  }

  /// Auto-sync pending products (called automatically when connectivity is restored)
  Future<void> _autoSyncPendingProducts() async {
    final pendingCount = getPendingProductsCount();
    if (pendingCount == 0) {
      return; // No pending products to sync
    }

    try {
      final result = await repository.syncPendingProducts();
      result.fold(
        (failure) {
          print('⚠️ Auto-sync failed: ${failure.errMessage}');
          // Don't show snackbar for auto-sync failures to avoid annoying users
        },
        (syncedProducts) {
          if (syncedProducts.isNotEmpty) {
            print('✅ Auto-synced ${syncedProducts.length} pending product(s)');
            // Refresh products list if available
            _refreshProductsList();
          }
        },
      );
    } catch (e) {
      print('⚠️ Auto-sync error: $e');
    }
  }

  /// Refresh products list after sync (if GetAllProductController is available)
  void _refreshProductsList() {
    try {
      final productController = Get.find<GetAllProductController>();
      productController.refreshProducts();
    } catch (e) {
      // Controller might not be initialized yet, that's okay
      print('ℹ️ Could not refresh products list: $e');
    }
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    networkInfo = NetworkInfoImpl();

    final remoteDataSource = AddProductRemoteDataSource(api: httpConsumer);
    final productBox = Hive.box<HiveProductModel>('productCache');
    final localDataSource = ProductLocalDataSourceImpl(productBox: productBox);
    final pendingProductBox =
        Hive.box<HivePendingProductModel>('pendingProducts');
    final pendingProductLocalDataSource =
        AddProductLocalDataSourceImpl(pendingProductBox: pendingProductBox);

    repository = AddProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      pendingProductLocalDataSource: pendingProductLocalDataSource,
      networkInfo: networkInfo,
    );

    addProductUseCase = GetAddProduct(repository: repository);
  }

  bool isFormValid() {
    return arabicTradeNameController.text.trim().isNotEmpty &&
        englishTradeNameController.text.trim().isNotEmpty &&
        quantityController.text.trim().isNotEmpty &&
        selectedForm.value != null &&
        barcodes.isNotEmpty &&
        selectedManufacturer.value != null;
  }

  // void validateForm() {
  //   arabicTradeNameError.value = arabicTradeNameController.text.trim().isEmpty
  //       ? 'Arabic product name is required'.tr
  //       : null;

  //   englishTradeNameError.value = englishTradeNameController.text.trim().isEmpty
  //       ? 'English product name is required'.tr
  //       : null;

  //   quantityError.value = quantityController.text.trim().isEmpty
  //       ? 'Please select a product quantity'.tr
  //       : null;

  //   formError.value =
  //       selectedForm.value == null ? 'Please select a product form'.tr : null;

  //   manufacturerError.value = selectedManufacturer.value == null
  //       ? 'Please select a manufacturer'.tr
  //       : null;
  // }

  // void clearValidationErrors() {
  //   arabicTradeNameError.value = null;
  //   englishTradeNameError.value = null;
  //   formError.value = null;
  //   manufacturerError.value = null;
  //   quantityError.value = null;
  // }
  void resetForm() {
    arabicTradeNameController.clear();
    englishTradeNameController.clear();
    arabicScientificNameController.clear();
    englishScientificNameController.clear();
    quantityController.clear();
    barcodeController.clear();
    dosageController.clear();
    notesController.clear();

    selectedForm.value = null;
    selectedManufacturer.value = null;
    selectedProductType.value = null;
    selectedFormId.value = 0;
    selectedManufacturerId.value = 0;
    selectedTypeId.value = 0;
    selectedCategoryIds.clear();
    barcodes.clear();
    requiresPrescription.value = false;
  }

  String getSelectedCategoryNames() {
    final dataController = Get.find<ProductDataController>();
    return selectedCategoryIds.map((id) {
      final list = dataController.dataList.cast<ProductDataModel>();
      final item = list.firstWhere(
        (e) => e.id == id,
        orElse: () => ProductDataModel(id: id, name: ''),
      );
      return item.name;
    }).join(', ');
  }

  void addBarcode() {
    final code = barcodeController.text.trim();
    if (code.isNotEmpty && !barcodes.contains(code)) {
      barcodes.add(code);
      barcodeController.clear();
    }
  }

  void removeBarcode(int index) {
    barcodes.removeAt(index);
  }

  void addScannedBarcode(String scannedCode) {
    if (scannedCode.isNotEmpty && !barcodes.contains(scannedCode)) {
      barcodes.add(scannedCode);
    }
  }

  Map<String, dynamic> buildRequestBody() {
    return {
      "tradeName": englishTradeNameController.text.trim(),
      "scientificName": englishScientificNameController.text.trim(),
      "concentration": dosageController.text.trim(),
      "size": quantityController.text.trim(),
      "notes": notesController.text.trim(),
      "tax": 0,
      "barcodes": barcodes.toList(),
      "requiresPrescription": requiresPrescription.value,
      "typeId": selectedTypeId.value,
      "formId": selectedFormId.value,
      "manufacturerId": selectedManufacturerId.value,
      "categoryIds": selectedCategoryIds.toList(),
      "translations": [
        {
          "tradeName": arabicTradeNameController.text.trim(),
          "scientificName": arabicScientificNameController.text.trim(),
          "lang": "ar",
        }
      ]
    };
  }

  Future<void> addProduct() async {
    // if (!isFormValid()) {
    //   validateForm();
    //   return;
    // }

    // clearValidationErrors();
    isLoading.value = true;

    try {
      final languageCode = LocaleController.to.locale.languageCode;
      final body = buildRequestBody();
      final params = AddProductParams(languageCode: languageCode);

      final result = await addProductUseCase(params: params, body: body);

      result.fold(
        (failure) {
          if (failure.statusCode == 409) {
            Get.snackbar('Error'.tr, "Barcode is already exists".tr);
          } else if (failure.statusCode == 401) {
            Get.snackbar('Error'.tr, "login cancel".tr);
          } else {
            Get.snackbar('Error'.tr, failure.errMessage);
          }
        },
        (product) {
          // Check if product was added offline
          // Offline products have specific default values we set:
          // quantity: 0, refPurchasePrice: 0, refSellingPrice: 0,
          // refPurchasePriceUSD: 0, refSellingPriceUSD: 0, form: '', etc.
          final isOfflineProduct = product.quantity == 0 &&
              product.refPurchasePrice == 0 &&
              product.refSellingPrice == 0 &&
              product.refPurchasePriceUSD == 0 &&
              product.refSellingPriceUSD == 0 &&
              product.form.isEmpty &&
              product.productType == 'Pharmacy';

          if (isOfflineProduct) {
            Get.snackbar(
              'Success'.tr,
              'Product saved offline. Will sync when back online.'.tr,
              duration: const Duration(seconds: 3),
            );
            // Update pending products count in GetAllProductController if available
            try {
              final productController = Get.find<GetAllProductController>();
              productController.updatePendingProductsCount();
            } catch (e) {
              // Controller might not be initialized yet, that's okay
            }
          } else {
            Get.snackbar('Success'.tr, 'Product added successfully'.tr);
            // Clean up duplicates after adding product online
            final productBox = Hive.box<HiveProductModel>('productCache');
            final localDataSource =
                ProductLocalDataSourceImpl(productBox: productBox);
            localDataSource.clearDuplicateProducts().then((_) {
              print('🧹 Cleaned up duplicates after adding product');
            }).catchError((e) {
              print('⚠️ Error cleaning duplicates: $e');
            });
          }
          resetForm();
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

  /// Sync pending products when back online
  Future<void> syncPendingProducts() async {
    try {
      isLoading.value = true;
      final result = await repository.syncPendingProducts();

      result.fold(
        (failure) {
          Get.snackbar('Sync Error'.tr, failure.errMessage);
        },
        (syncedProducts) {
          if (syncedProducts.isEmpty) {
            Get.snackbar('Sync'.tr, 'No pending products to sync.'.tr);
          } else {
            Get.snackbar(
              'Sync Success'.tr,
              'Synced ${syncedProducts.length} product(s) successfully.'.tr,
            );
            // Refresh products list after successful sync
            _refreshProductsList();
          }
        },
      );
    } catch (e) {
      Get.snackbar('Sync Error'.tr, 'Failed to sync products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Get count of pending products
  int getPendingProductsCount() {
    return repository.getPendingProductsCount();
  }
}
