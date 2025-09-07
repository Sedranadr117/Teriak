// controllers/add_supplier_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/features/suppliers/add_supplier/data/datasources/add_supplier_remote_data_source.dart';
import 'package:teriak/features/suppliers/add_supplier/data/repositories/add_supplier_repository_impl.dart';
import 'package:teriak/features/suppliers/add_supplier/domain/usecases/post_add_supplierdart';

class AddSupplierController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final selectedCurrency = 'USD'.obs;
  var hasUnsavedChanges = false;

  late final NetworkInfoImpl networkInfo;
  late final PostAddSupplier addSupplierUseCase;
  var isLoading = false.obs;
  final RxString errorMessage = ''.obs;

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

    final remoteDataSource = AddSupplierRemoteDataSource(api: httpConsumer);

    final repository = AddSupplierRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    addSupplierUseCase = PostAddSupplier(repository: repository);
  }

  void updateCurrency(String value) {
    selectedCurrency.value = value;
    hasUnsavedChanges = true;
  }

  String? validatePhoneNumber(String value) {
    final phoneRegex = RegExp(r'^09\d{8}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'الرجاء إدخال رقم صحيح يبدأ بـ 09 ومكون من 10 أرقام';
    }
    return null;
  }

  bool isFormValid() {
    final nameValid = nameController.text.trim().isNotEmpty;
    final addressValid = addressController.text.trim().isNotEmpty;

    final phoneText = phoneController.text.trim();
    final phoneValid =
        phoneText.isNotEmpty && validatePhoneNumber(phoneText) == null;

    return nameValid && addressValid && phoneValid;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }

  void resetForm() {
    nameController.clear();
    phoneController.clear();
    addressController.clear();
  }

  Map<String, dynamic> buildBody() {
    return {
      "name": nameController.text.trim(),
      "phone": phoneController.text.trim(),
      "address": addressController.text.trim(),
      "preferredCurrency": selectedCurrency.value,
    };
  }

  Future<void> addSupplier() async {
    isLoading.value = true;

    try {
      final body = buildBody();

      final result = await addSupplierUseCase(body: body);

      result.fold(
        (failure) {
          if (failure.statusCode == 409) {
            Get.snackbar('Error'.tr,
                "Supplier name must be unique within this pharmacy".tr);
          }
          if (failure.statusCode == 401) {
            Get.snackbar('Error'.tr, "login cancel".tr);
          } else {
            Get.snackbar('Error'.tr, failure.errMessage);
          }
        },
        (product) {
          Get.snackbar('Success'.tr, 'Supplier added successfully'.tr);
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
}
