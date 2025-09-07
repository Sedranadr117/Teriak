import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/money_box/data/datasources/post_money_box_transaction_remote_data_source.dart';
import 'package:teriak/features/money_box/data/repositories/add_money_box_transaction_repository_impl.dart';
import 'package:teriak/features/money_box/domain/usecases/add_money_box_transaction.dart';

class AddMoneyBoxTransactionController extends GetxController {
  // Form controllers
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString transactionType = 'deposit'.obs;

  late final NetworkInfoImpl networkInfo;
  late final PostMoneyBoxTransaction addMoneyBoxTransactionUseCase;

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
        AddMoneyBoxTransactionRemoteDataSource(api: httpConsumer);
    final repository = AddMoneyBoxTransactionRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    addMoneyBoxTransactionUseCase =
        PostMoneyBoxTransaction(repository: repository);
  }

  @override
  void onClose() {
    amountController.dispose();
    notesController.dispose();
    super.onClose();
  }

  // Validate form
  bool validateForm() {
    if (amountController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter amount'.tr;
      return false;
    }
    if (notesController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter notes'.tr;
      return false;
    }

    final amount = amountController.text.trim();
    if (amount == " ") {
      errorMessage.value = 'Please enter a valid amount'.tr;
      return false;
    }

    errorMessage.value = '';
    return true;
  }

  // Add money box transaction
  Future<void> addTransaction() async {
    if (!validateForm()) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final rawAmount = double.parse(amountController.text.trim());
      final amount =
          transactionType.value == 'withdraw' ? -rawAmount : rawAmount;
      final description = notesController.text.trim();

      final params = MoneyBoxTransactionParams(
        amount: amount,
        description: description,
      );
      print('🔍 Created MoneyBoxTransactionParams: ${params.toString()}');

      final result = await addMoneyBoxTransactionUseCase.call(params: params);

      result.fold(
        (failure) {
          if (failure.statusCode == 401) {
            Get.snackbar('Error'.tr, "login cancel".tr);
          } else {
            errorMessage.value = failure.errMessage;
          }
        },
        (moneyBox) {
          Get.snackbar(
            'Success'.tr,
            'Transaction added successfully'.tr,
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

  // Clear form
  void clearForm() {
    amountController.clear();
    notesController.clear();
    errorMessage.value = '';
  }

  // Clear error message
  void clearError() {
    errorMessage.value = '';
  }
}
