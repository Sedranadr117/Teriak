import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/add_product/data/datasources/add_product_remote_data_source.dart';
import 'package:teriak/features/add_product/data/repositories/add_product_repository_impl.dart';
import 'package:teriak/features/add_product/domain/usecases/post_add_product.dart';
import 'package:teriak/features/product_data/data/models/product_data_model.dart';
import 'package:teriak/features/product_data/presentation/controller/product_data_controller.dart';

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
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    networkInfo = NetworkInfoImpl(InternetConnection());

    final remoteDataSource = AddProductRemoteDataSource(api: httpConsumer);

    final repository = AddProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
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

  @override
  void onClose() {
    arabicTradeNameController.dispose();
    englishTradeNameController.dispose();
    englishScientificNameController.dispose();
    arabicScientificNameController.dispose();
    quantityController.dispose();
    barcodeController.dispose();
    dosageController.dispose();
    notesController.dispose();
    //minStockController.dispose();
    super.onClose();
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
            Get.snackbar('Error', "Barcode is already exists".tr);
          } else {
            Get.snackbar('Error', failure.errMessage);
          }
        },
        (product) {
          Get.snackbar('Success', 'Product added successfully'.tr);
          resetForm();
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
