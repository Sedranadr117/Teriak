import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/products/all_products/domain/entities/product_entity.dart';
import 'package:teriak/features/products/search_product/data/datasources/search_product_remote_data_source.dart';
import 'package:teriak/features/products/search_product/data/repositories/search_product_repository_impl.dart';
import 'package:teriak/features/products/search_product/domain/usecases/search_product.dart';

class SearchProductController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();

  late final NetworkInfoImpl networkInfo;
  late final SearchProduct searchProductUseCase;

  // Search state
  var isSearching = false.obs;
  var results = <ProductEntity>[].obs;
  var errorMessage = ''.obs;
  final Rx<RxStatus?> searchStatus = Rx<RxStatus?>(null);

  // Pagination
  var currentPage = 0.obs;
  var pageSize = 10.obs;
  var totalPages = 0.obs;
  var totalElements = 0.obs;
  var hasNext = false.obs;
  var hasPrevious = false.obs;
  var isLoadingMore = false.obs;

  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();

    // // Optional: debounce for search input
    // searchController.addListener(() {
    //   if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    //   _debounceTimer = Timer(const Duration(milliseconds: 500), () {
    //     final query = searchController.text.trim();
    //     if (query.isEmpty) {
    //       clearSearch();
    //       return;
    //     }
    //     search(query, refresh: true);
    //   });
    // });
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    networkInfo = NetworkInfoImpl();

    final remoteDataSource = SearchProductRemoteDataSource(api: httpConsumer);

    final repository = SearchProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    searchProductUseCase = SearchProduct(repository: repository);
  }

  Future<void> search(String query, {bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 0;
        results.clear();
      }

      isSearching.value = true;
      searchStatus.value = RxStatus.loading();
      errorMessage.value = '';

      final params = SearchProductParams(
        keyword: query,
        languageCode: LocaleController.to.locale.languageCode,
        page: currentPage.value,
        size: pageSize.value,
      );

      final result = await searchProductUseCase(params: params);
      result.fold(
        (failure) {
          results.clear();
          errorMessage.value = failure.errMessage;
          searchStatus.value = RxStatus.error(failure.errMessage);
        },
        (paginatedData) {
          // دمج البيانات الجديدة مع الموجودة مع uniqueness حسب id + productType
          final newResults = <ProductEntity>[];
          for (var product in paginatedData.content) {
            bool exists = results.any((p) =>
                p.id == product.id && p.productType == product.productType);
            if (!exists) newResults.add(product);
          }

          results.addAll(newResults);

          totalPages.value = paginatedData.totalPages;
          totalElements.value = paginatedData.totalElements;
          hasNext.value = paginatedData.hasNext;
          hasPrevious.value = paginatedData.hasPrevious;

          if (results.isEmpty) {
            searchStatus.value = RxStatus.empty();
          } else {
            searchStatus.value = RxStatus.success();
          }
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      searchStatus.value = RxStatus.error(e.toString());
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> loadNextPage() async {
    if (!hasNext.value ||
        isLoadingMore.value ||
        searchController.text.isEmpty) {
      return;
    }

    try {
      isLoadingMore.value = true;
      currentPage.value++;

      final query = searchController.text.trim();
      await search(query);
    } finally {
      isLoadingMore.value = false;
    }
  }

  void clearSearch() {
    results.clear();
    currentPage.value = 0;
    totalPages.value = 0;
    totalElements.value = 0;
    hasNext.value = false;
    hasPrevious.value = false;
    errorMessage.value = '';
    searchStatus.value = null;
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocus.dispose();
    _debounceTimer?.cancel();
    super.onClose();
  }
}
