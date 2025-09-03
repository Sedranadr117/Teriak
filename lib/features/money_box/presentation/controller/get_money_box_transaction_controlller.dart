import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/money_box/data/datasources/get_money_box_transaction_remote_data_source.dart';
import 'package:teriak/features/money_box/data/repositories/get_money_box_transaction_repository_impl.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_transaction_entity.dart';
import 'package:teriak/features/money_box/domain/usecases/get_money_box_transaction.dart';

class GetMoneyBoxTransactionController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<MoneyBoxTransactionPaginatedEntity?> transactions =
      Rx<MoneyBoxTransactionPaginatedEntity?>(null);
  final RxInt currentPage = 0.obs;
  final RxInt pageSize = 10.obs;

  late final NetworkInfoImpl networkInfo;
  late final GetMoneyBoxTransactions getMoneyBoxTransactionsUseCase;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    getTransactionsData();
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);
    networkInfo = NetworkInfoImpl();
    final remoteDataSource =
        MoneyBoxTransactionRemoteDataSource(api: httpConsumer);
    final repository = MoneyBoxTransactionRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    getMoneyBoxTransactionsUseCase =
        GetMoneyBoxTransactions(repository: repository);
  }

  Future<void> getTransactionsData({int? page}) async {
    if (page != null) {
      currentPage.value = page;
    }

    isLoading.value = true;
    errorMessage.value = '';

    final params = GetMoneyBoxTransactionParams(
      page: currentPage.value,
      size: pageSize.value,
    );

    final result = await getMoneyBoxTransactionsUseCase(params: params);

    result.fold(
      (failure) {
        errorMessage.value = failure.errMessage;
        isLoading.value = false;
      },
      (transactionsData) {
        transactions.value = transactionsData;
        isLoading.value = false;
      },
    );
  }

  void nextPage() {
    if (transactions.value?.hasNext == true) {
      getTransactionsData(page: currentPage.value + 1);
    }
  }

  void previousPage() {
    if (transactions.value?.hasPrevious == true) {
      getTransactionsData(page: currentPage.value - 1);
    }
  }

  void goToPage(int page) {
    if (page >= 0 && page < (transactions.value?.totalPages ?? 0)) {
      getTransactionsData(page: page);
    }
  }

  void refreshData() {
    getTransactionsData(page: 0);
  }
}
