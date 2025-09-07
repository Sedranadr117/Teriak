import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/money_box/data/datasources/post_money_box_reconcile_remote_data_source .dart';
import 'package:teriak/features/money_box/data/repositories/add_money_box_reconcile_repository_impl.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_entity.dart';
import 'package:teriak/features/money_box/domain/usecases/add_money_box_concile.dart';

class AddMoneyBoxReconcileController extends GetxController {
  final TextEditingController actualAmountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  late final NetworkInfoImpl networkInfo;
  late final PostMoneyBoxReConcile addMoneyBoxReconcileUseCase;

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
        AddMoneyBoxReConcileRemoteDataSource(api: httpConsumer);
    final repository = AddMoneyBoxReconcileRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    addMoneyBoxReconcileUseCase = PostMoneyBoxReConcile(repository: repository);
  }

  @override
  void onClose() {
    actualAmountController.dispose();
    notesController.dispose();
    super.onClose();
  }

  bool validateForm() {
    if (actualAmountController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter actual amount'.tr;
      return false;
    }
       if (notesController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter notes'.tr;
      return false;
    }

    final amount = actualAmountController.text.trim();
    if (double.tryParse(amount) == null) {
      errorMessage.value = 'Please enter a valid amount'.tr;
      return false;
    }

    errorMessage.value = '';
    return true;
  }

  Future<void> addReconcile() async {
    if (!validateForm()) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final actualAmount = double.parse(actualAmountController.text.trim());
      final notes = notesController.text.trim();

      final params = ReconcileMoneyBoxParams(
        actualCashCount: actualAmount,
        notes: notes,
      );

      final result = await addMoneyBoxReconcileUseCase.call(params: params);

      result.fold(
        (failure) {
          if (failure.statusCode == 401) {
            Get.snackbar('Error'.tr, "login cancel".tr);
          }
          else{
          errorMessage.value = failure.errMessage;
          }
        },
        (moneyBox) {
          Get.snackbar(
            'Success'.tr,
            'Money box reconciled successfully'.tr,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.transparent,
            colorText: Colors.white,
          );
          clearForm();
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

  void clearForm() {
    actualAmountController.clear();
    notesController.clear();
    errorMessage.value = '';
  }

  void clearError() {
    errorMessage.value = '';
  }
}
