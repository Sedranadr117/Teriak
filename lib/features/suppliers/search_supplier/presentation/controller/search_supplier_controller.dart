import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/suppliers/search_supplier/data/datasources/search_supplier_remote_data_source.dart';
import 'package:teriak/features/suppliers/search_supplier/data/repositories/search_supplier_repository_impl.dart';
import 'package:teriak/features/suppliers/search_supplier/domain/usecases/search_supplier.dart';

class SearchSupplierController extends GetxController {
    final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode searchFocus = FocusNode();
  late final NetworkInfoImpl networkInfo;
  late final SearchSupplier searchSupplierUseCase;

  var isSearching = false.obs;
  var results = [].obs;
  var errorMessage = ''.obs;
  final Rx<RxStatus?> searchStatus = Rx<RxStatus?>(null);

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

    final remoteDataSource = SearchSupplierRemoteDataSource(api: httpConsumer);

    final repository = SearchSupplierRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    searchSupplierUseCase = SearchSupplier(repository: repository);
  }

  Future<void> search(String query) async {
    try {
      searchStatus.value = RxStatus.loading();
      print('Search Status: Loading');
      errorMessage.value = '';
      final q = SearchSupplierParams(
        keyword: query,
      );
      final result = await searchSupplierUseCase(params: q);
      result.fold(
        (failure) {
          results.clear();
          errorMessage.value = failure.errMessage;
          searchStatus.value = RxStatus.error(failure.errMessage);
          print('Search Error: ${failure.errMessage}');
        },
        (list) {
          results.value = list;
          print('Search Results: ${results.length} items');
          if (list.isEmpty) {
            results.clear();
            searchStatus.value = RxStatus.empty();
            print('Search Status: Empty Results');
          } else {
            results.value = list;
            searchStatus.value = RxStatus.success();
            print('Search Status: Success, Results Count: ${list.length}');
          }
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      searchStatus.value = RxStatus.error(e.toString());
      print('Search Status: Error: ${e.toString()}');
    }
  }
}
