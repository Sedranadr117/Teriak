// controllers/add_supplier_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import 'package:teriak/features/suppliers/edit_supplier/data/datasources/edit_supplier_remote_data_source.dart';
import 'package:teriak/features/suppliers/edit_supplier/data/repositories/edit_supplier_repository_impl.dart';
import 'package:teriak/features/suppliers/edit_supplier/domain/usecases/put_edit_supplier.dart';

class EditSupplierController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final selectedCurrency = 'USD'.obs;
  var hasUnsavedChanges = false;

  late final NetworkInfoImpl networkInfo;
  late final PutEditSupplier editSupplierUseCase;
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

    final remoteDataSource = EditSupplierRemoteDataSource(api: httpConsumer);

    final repository = EditSupplierRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    editSupplierUseCase = PutEditSupplier(repository: repository);
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

  void loadSupplierData(SupplierModel supplier) async {
    nameController.text = supplier.name;
    phoneController.text = supplier.phone;
    addressController.text = supplier.address;
    selectedCurrency.value = supplier.preferredCurrency;
  }

  Map<String, dynamic> buildBody() {
    return {
      ApiKeys.name: nameController.text.trim(),
      ApiKeys.phone: phoneController.text.trim(),
      ApiKeys.address: addressController.text.trim(),
      ApiKeys.preferredCurrency: selectedCurrency.value,
    };
  }

  Future<void> editSupplier(int supplierId) async {
    isLoading.value = true;

    try {
      final body = buildBody();
      final params = SupplierParams(
        id: supplierId,
      );

      final result = await editSupplierUseCase(params: params, body: body);

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.errMessage);
        },
        (supplier) {
          Get.snackbar('Success', 'Supplier updated successfully');
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
