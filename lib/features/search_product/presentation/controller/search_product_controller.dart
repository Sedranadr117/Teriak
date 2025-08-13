import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/search_product/data/datasources/search_product_remote_data_source.dart';
import 'package:teriak/features/search_product/data/repositories/search_product_repository_impl.dart';
import 'package:teriak/features/search_product/domain/usecases/search_product.dart';

class SearchProductController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  late final NetworkInfoImpl networkInfo;
  late final SearchProduct searchProductUseCase;

  var isSearching = false.obs;
  var results = [].obs;
  var errorMessage = ''.obs;
  final Rx<RxStatus?> searchStatus = Rx<RxStatus?>(null);

  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();

    //   searchController.addListener(() {
    //     if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    //     _debounceTimer = Timer(const Duration(milliseconds: 500), () {
    //       final query = searchController.text.trim();
    //       if (query.isEmpty) {
    //         results.clear();
    //         errorMessage.value = '';
    // searchStatus.value = null;
    //         return;
    //       }
    //       search(query);
    //     });
    // });
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    searchFocus.dispose();

    super.onClose();
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    networkInfo = NetworkInfoImpl(InternetConnection());

    final remoteDataSource = SearchProductRemoteDataSource(api: httpConsumer);

    final repository = SearchProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    searchProductUseCase = SearchProduct(repository: repository);
  }

  Future<void> search(String query) async {
    try {
      searchStatus.value = RxStatus.loading();
      String currentLanguageCode = LocaleController.to.locale.languageCode;
      print('Search Status: Loading');
      errorMessage.value = '';
      final q = SearchProductParams(
        keyword: query,
        languageCode: currentLanguageCode,
      );
      final result = await searchProductUseCase(params: q);
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
