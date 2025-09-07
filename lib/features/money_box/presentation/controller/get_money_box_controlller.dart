import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/features/money_box/data/datasources/get_money_box_remote_data_source.dart';
import 'package:teriak/features/money_box/data/repositories/get_money_box_repository_impl.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_entity.dart';
import 'package:teriak/features/money_box/domain/usecases/get_money_box.dart';

class GetMoneyBoxController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<MoneyBoxEntity?> moneyBox = Rx<MoneyBoxEntity?>(null);

  late final NetworkInfoImpl networkInfo;
  late final GetMoneyBox getMoneyBoxUseCase;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    getMoneyBoxData();
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);
    networkInfo = NetworkInfoImpl();
    final remoteDataSource = MoneyBoxRemoteDataSource(api: httpConsumer);
    final repository = MoneyBoxRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    getMoneyBoxUseCase = GetMoneyBox(repository: repository);
  }

  Future<void> getMoneyBoxData() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await getMoneyBoxUseCase();

    result.fold(
      (failure) {
        if (failure.statusCode == 401) {
          Get.snackbar('Error'.tr, "login cancel".tr);
        } else {
          errorMessage.value = failure.errMessage;
        }

        isLoading.value = false;
      },
      (moneyBoxData) {
        moneyBox.value = moneyBoxData;
        isLoading.value = false;
      },
    );
  }

  Future<void> refreshData() async {
    getMoneyBoxData();
  }
}
