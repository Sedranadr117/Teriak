import 'package:get/get.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/products/all_products/data/datasources/product_remote_data_source.dart';
import 'package:teriak/features/products/all_products/data/repositories/product_repository_impl.dart';
import 'package:teriak/features/products/all_products/domain/entities/product_entity.dart';
import 'package:teriak/features/products/all_products/domain/usecases/get_product.dart';

class GetAllProductController extends GetxController {
  late final NetworkInfoImpl networkInfo;
  late final GetAllProduct getAllProductUseCase;

  var isLoading = true.obs;
  var products = <ProductEntity>[].obs;
  var errorMessage = ''.obs;
  var isRefreshing = false.obs;

  // Pagination variables
  var currentPage = 0.obs;
  var pageSize = 10.obs;
  var totalPages = 0.obs;
  var totalElements = 0.obs;
  var hasNext = false.obs;
  var hasPrevious = false.obs;
  var isLoadingMore = false.obs;

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

    final remoteDataSource = ProductRemoteDataSource(api: httpConsumer);

    final repository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    getAllProductUseCase = GetAllProduct(repository: repository);
    getProducts();
  }

  void getProducts({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 0;
        isLoading.value = true;
        products.clear();
      } else {
        isLoading.value = true;
      }

      String currentLanguageCode = LocaleController.to.locale.languageCode;
      final params = AllProductParams(
        languageCode: currentLanguageCode,
        page: currentPage.value,
        size: pageSize.value,
      );

      final result = await getAllProductUseCase(params: params);
      result.fold(
        (failure) {
          if (failure.statusCode == 401) {
            Get.snackbar('Error'.tr, "login cancel".tr);
          } else {
            errorMessage.value = failure.errMessage;
          }
        },
        (paginatedData) {
          final newProducts = <ProductEntity>[];
          for (var product in paginatedData.content) {
            bool exists = products.any((p) =>
                p.id == product.id && p.productType == product.productType);
            if (!exists) {
              newProducts.add(product);
            }
          }

          if (refresh) {
            products.value = newProducts;
          } else {
            products.addAll(newProducts);
          }

          totalPages.value = paginatedData.totalPages;
          totalElements.value = paginatedData.totalElements;
          hasNext.value = paginatedData.hasNext;
          hasPrevious.value = paginatedData.hasPrevious;
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

  Future<void> loadNextPage() async {
    if (hasNext.value && !isLoadingMore.value) {
      try {
        isLoadingMore.value = true;
        currentPage.value++;

        String currentLanguageCode = LocaleController.to.locale.languageCode;
        final params = AllProductParams(
          languageCode: currentLanguageCode,
          page: currentPage.value,
          size: pageSize.value,
        );

        final result = await getAllProductUseCase(params: params);
        result.fold(
          (failure) {
            if (failure.statusCode == 401) {
              errorMessage.value = '';
              Get.snackbar('Error'.tr, "login cancel".tr);
            } else {
              errorMessage.value = failure.errMessage;
            }
          },
          (paginatedData) {
            final newProducts = <ProductEntity>[];
            for (var product in paginatedData.content) {
              bool exists = products.any((p) =>
                  p.id == product.id && p.productType == product.productType);
              if (!exists) {
                newProducts.add(product);
              }
            }
            products.addAll(newProducts);

            totalPages.value = paginatedData.totalPages;
            totalElements.value = paginatedData.totalElements;
            hasNext.value = paginatedData.hasNext;
            hasPrevious.value = paginatedData.hasPrevious;
          },
        );
      } catch (e) {
        errorMessage.value =
            'An unexpected error occurred. Please try again.'.tr;
        Get.snackbar(
          'Error'.tr,
          errorMessage.value,
        );
      } finally {
        isLoadingMore.value = false;
      }
    }
  }

  Future<void> refreshProducts() async {
    try {
      isRefreshing.value = true;
      await Future.delayed(const Duration(milliseconds: 1500));
      getProducts(refresh: true);
    } finally {
      isRefreshing.value = false;
    }
  }
}
