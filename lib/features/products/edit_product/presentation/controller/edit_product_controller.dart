import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/products/edit_product/data/datasources/edit_product_remote_data_source.dart';
import 'package:teriak/features/products/edit_product/data/repositories/edit_product_repository_impl.dart';
import 'package:teriak/features/products/edit_product/domain/usecases/put_edit_product.dart';
import 'package:teriak/features/products/all_products/data/models/product_model.dart';
import 'package:teriak/features/products/product_data/data/models/product_data_model.dart';
import 'package:teriak/features/products/product_data/presentation/controller/product_data_controller.dart';
import 'package:teriak/features/products/product_data/presentation/controller/product_names_controller.dart';

class EditProductController extends GetxController {
  // Controllers
  final arabicTradeNameController = TextEditingController();
  final englishTradeNameController = TextEditingController();
  final sizeController = TextEditingController();
  final barcodeController = TextEditingController();
  final arabicScientificNameController = TextEditingController();
  final englishScientificNameController = TextEditingController();
  final dosageController = TextEditingController();
  final notesController = TextEditingController();

  // Reactive variables
  var selectedForm = RxnString();
  var selectedManufacturer = RxnString();
  var selectedProductType = RxnString();
  var selectedClassification = <dynamic>[].obs;
  var requiresPrescription = false.obs;
  var barcodes = <String>[].obs;
  var hasChanges = false.obs;

  var selectedFormId = 0.obs;
  var selectedManufacturerId = 0.obs;
  var selectedTypeId = 0.obs;
  var selectedCategoryIds = <int>[].obs;

  // Expanded sections
  var basicInfoExpanded = false.obs;
  var basicInfoLoading = true.obs;
  var barcodeExpanded = false.obs;
  var additionalInfoExpanded = false.obs;
  late final NetworkInfoImpl networkInfo;
  late final PutEditProduct editProductUseCase;
  var isLoading = false.obs;

  late ProductModel originalProduct;

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

    final remoteDataSource = EditProductRemoteDataSource(api: httpConsumer);

    final repository = EditProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    editProductUseCase = PutEditProduct(repository: repository);
  }

  // Original data

  Future<void> loadProductData(ProductModel product) async {
    originalProduct = product;

    selectedForm.value = product.form;
    selectedManufacturer.value = product.manufacturer;
    sizeController.text = product.size;
    barcodes.assignAll((product.barcodes ?? []).cast<String>());
    dosageController.text = product.concentration;
    selectedProductType.value = product.type;
    selectedClassification.assignAll((product.categories ?? []).cast<String>());
    requiresPrescription.value = product.requiresPrescription;
    notesController.text = product.notes ?? '';

    final dataController = Get.find<ProductDataController>();

    //  Forms
    await dataController.getProductData('forms');
    final forms = dataController.dataList.cast<ProductDataModel>();
    final formMatch = forms.firstWhere(
      (e) => e.name == product.form,
      orElse: () => ProductDataModel(id: 0, name: ''),
    );
    selectedFormId.value = formMatch.id;

    // Manufacturers
    await dataController.getProductData('manufacturers');
    final manufacturers = dataController.dataList.cast<ProductDataModel>();
    final manufacturerMatch = manufacturers.firstWhere(
      (e) => e.name == product.manufacturer,
      orElse: () => ProductDataModel(id: 0, name: ''),
    );
    selectedManufacturerId.value = manufacturerMatch.id;

    //  Types
    await dataController.getProductData('types');
    final types = dataController.dataList.cast<ProductDataModel>();
    final typeMatch = types.firstWhere(
      (e) => e.name == product.type,
      orElse: () => ProductDataModel(id: 0, name: ''),
    );
    selectedTypeId.value = typeMatch.id;

    // Categories
    await dataController.getProductData('categories');
    final categories = dataController.dataList.cast<ProductDataModel>();
    selectedCategoryIds.assignAll(
      selectedClassification.map((name) {
        final match = categories.firstWhere(
          (cat) => cat.name == name,
          orElse: () => ProductDataModel(id: -1, name: name),
        );
        return match.id;
      }).where((id) => id != -1),
    );

    final namesController = Get.put(ProductNamesController());

    await namesController.getProductNames(product.productType, product.id);
    final fetchedNames = namesController.productNames.value;
    if (fetchedNames != null) {
      arabicTradeNameController.text = fetchedNames.tradeNameAr;
      englishTradeNameController.text = fetchedNames.tradeNameEn;
      arabicScientificNameController.text = fetchedNames.scientificNameAr;
      englishScientificNameController.text = fetchedNames.scientificNameEn;
    }
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

  bool isFormValid() {
    return arabicTradeNameController.text.trim().isNotEmpty &&
        englishTradeNameController.text.trim().isNotEmpty &&
        sizeController.text.trim().isNotEmpty &&
        selectedForm.value != null &&
        barcodes.isNotEmpty &&
        selectedManufacturer.value != null;
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

  // @override
  // void onClose() {
  //   arabicTradeNameController.dispose();
  //   englishTradeNameController.dispose();
  //   sizeController.dispose();
  //   barcodeController.dispose();
  //   arabicScientificNameController.dispose();
  //   englishScientificNameController.dispose();
  //   dosageController.dispose();
  //   notesController.dispose();
  //   super.onClose();
  // }

  Map<String, dynamic> buildRequestBody() {
    return {
      "tradeName": englishTradeNameController.text.trim(),
      "scientificName": englishScientificNameController.text.trim(),
      "concentration": dosageController.text.trim(),
      "size": sizeController.text.trim(),
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
          "lang": "ar"
        }
      ]
    };
  }

  Future<void> editProduct(int productId) async {
    isLoading.value = true;
    try {
      final body = buildRequestBody();

      final languageCode = LocaleController.to.locale.languageCode;

      final params = EditProductParams(
        languageCode: languageCode,
        id: productId,
      );

      final result = await editProductUseCase(params: params, body: body);

      result.fold(
        (failure) {
          if (failure.statusCode == 409) {
            Get.snackbar('Error', "Barcode is already exists".tr);
          } else {
            Get.snackbar('Error', failure.errMessage);
          }
        },
        (updatedProduct) {
          Get.snackbar('Success', 'Product updated successfully'.tr);
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
