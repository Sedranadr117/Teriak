import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/features/money_box/data/datasources/post_money_box_remote_data_source.dart';
import 'package:teriak/features/money_box/data/repositories/add_money_box_repository_impl.dart';
import 'package:teriak/features/money_box/domain/usecases/add_money_box.dart';

class AddMoneyBoxController extends GetxController {
  // Form controllers
  final TextEditingController initialBalanceController =
      TextEditingController();
  final TextEditingController currencyController = TextEditingController();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isFormVisible = false.obs;
  final RxString selectedCurrency = 'USD'.obs;
  final RxString errorMessage = ''.obs;

  // Currency options
  final List<String> currencyOptions = ['USD', 'SYP'];

  late final NetworkInfoImpl networkInfo;
  late final PostMoneyBox addMoneyBoxUseCase;

  @override
  void onInit() {
    super.onInit();
    selectedCurrency.value = 'USD';
    _initializeDependencies();
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    networkInfo = NetworkInfoImpl();

    final remoteDataSource = AddMoneyBoxRemoteDataSource(api: httpConsumer);

    final repository = AddMoneyBoxRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    addMoneyBoxUseCase = PostMoneyBox(repository: repository);
  }

  @override
  void onClose() {
    initialBalanceController.dispose();
    currencyController.dispose();
    super.onClose();
  }

  // Show the form
  void showForm() {
    isFormVisible.value = true;
    errorMessage.value = '';
  }

  // Hide the form
  void hideForm() {
    isFormVisible.value = false;
    initialBalanceController.clear();
    errorMessage.value = '';
  }

  // Set selected currency
  void setCurrency(String currency) {
    selectedCurrency.value = currency;
  }

  // Validate form
  bool validateForm() {
    if (initialBalanceController.text.trim().isEmpty) {
      errorMessage.value = 'Please enter initial balance'.tr;
      return false;
    }

    final balance = double.tryParse(initialBalanceController.text.trim());
    if (balance == null || balance <= 0) {
      errorMessage.value = 'Please enter a valid positive number'.tr;
      return false;
    }

    if (selectedCurrency.value.isEmpty) {
      errorMessage.value = 'Please select currency'.tr;
      return false;
    }

    errorMessage.value = '';
    return true;
  }

  // Open money box
  Future<void> openMoneyBox() async {
    if (!validateForm()) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final balance = double.parse(initialBalanceController.text.trim());

      final body = {
        "currency": selectedCurrency.value,
        "initialBalance": balance,
      };
      print(body);

      final result = await addMoneyBoxUseCase.call(body: body);

      result.fold(
        (failure) {
          errorMessage.value = failure.errMessage;
        },
        (moneyBox) {
          Get.snackbar(
            'Success'.tr,
            'Money box opened successfully'.tr,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.transparent,
            colorText: Colors.white,
          );
          hideForm();
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  // Clear error message
  void clearError() {
    errorMessage.value = '';
  }
}
