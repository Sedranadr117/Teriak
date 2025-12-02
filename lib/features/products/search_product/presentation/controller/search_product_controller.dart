import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/products/all_products/data/datasources/product_local_data_source.dart';
import 'package:teriak/features/products/all_products/data/models/hive_product_model.dart';
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

  // Expose debounceTimer for canceling in search_bar
  Timer? get debounceTimer => _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();

    // Enable real-time search with debouncing (300ms for faster response)
    searchController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    // Cancel previous timer if active
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    final query = searchController.text.trim();

    // If empty, clear search immediately
    if (query.isEmpty) {
      clearSearch();
      return;
    }

    // Start new timer for real-time search (300ms debounce)
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      final trimmedQuery = searchController.text.trim();
      if (trimmedQuery.isEmpty) {
        clearSearch();
        return;
      }
      // Search in cache immediately (fast, works offline)
      search(trimmedQuery, refresh: true);
    });
  }

  /// Set search text programmatically (e.g., from QR scanner)
  /// This will trigger onChanged which will automatically search via the debounce timer
  void setSearchText(String text) {
    searchController.text = text;
    // The listener will automatically trigger _onSearchTextChanged
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    networkInfo = NetworkInfoImpl();

    final remoteDataSource = SearchProductRemoteDataSource(api: httpConsumer);
    final productBox = Hive.box<HiveProductModel>('productCache');
    final localDataSource = ProductLocalDataSourceImpl(productBox: productBox);

    final repository = SearchProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
      localDataSource: localDataSource,
    );

    searchProductUseCase = SearchProduct(repository: repository);
  }

  Future<void> search(String query, {bool refresh = false}) async {
    // Cancel any pending debounce timer
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

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
          {
            if (failure.statusCode == 401) {
              Get.snackbar('Error'.tr, "login cancel".tr);
            } else {
              errorMessage.value = failure.errMessage;
            }
          }
          searchStatus.value = RxStatus.error(failure.errMessage);
        },
        (paginatedData) {
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
      errorMessage.value = 'An unexpected error occurred. Please try again.'.tr;
      Get.snackbar(
        'Error'.tr,
        errorMessage.value,
      );
      searchStatus.value =
          RxStatus.error('An unexpected error occurred. Please try again.'.tr);
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> loadNextPage() async {
    if (!hasNext.value || isLoadingMore.value || searchController.text.isEmpty)
      return;

    try {
      isLoadingMore.value = true;
      currentPage.value++;

      final query = searchController.text.trim();
      await search(query);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred. Please try again.'.tr;
      Get.snackbar(
        'Error'.tr,
        errorMessage.value,
      );
      currentPage.value--;
      isSearching.value = false;
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
