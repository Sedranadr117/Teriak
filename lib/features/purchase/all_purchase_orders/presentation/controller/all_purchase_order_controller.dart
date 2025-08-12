import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/purchase/all_purchase_orders/data/datasources/all_purchase_remote_data_source.dart';
import 'package:teriak/features/purchase/all_purchase_orders/data/repositories/all_purchase_repository_impl.dart';
import 'package:teriak/features/purchase/all_purchase_orders/domain/usecases/get_all_purchase.dart';

class GetAllPurchaseOrderController extends GetxController {
  late final NetworkInfoImpl networkInfo;
  late final GetAllPurchaseOrders getAllPurchaseUseCase;
  var isLoading = true.obs;
  var purchaseOrders = [].obs;
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

    networkInfo = NetworkInfoImpl(InternetConnection());

    final remoteDataSource =
        AllPurchaseOrdersRemoteDataSource(api: httpConsumer);

    final repository = AllPurchaseOrdersRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    getAllPurchaseUseCase = GetAllPurchaseOrders(repository: repository);
    getPurchaseOrders();
  }

  void getPurchaseOrders({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 0;
        isLoading.value = true;
      } else {
        isLoading.value = true;
      }

      String currentLanguageCode = LocaleController.to.locale.languageCode;
      final params = PaginationParams(
        page: currentPage.value,
        size: pageSize.value,
        languageCode: currentLanguageCode,
      );

      final result = await getAllPurchaseUseCase(params: params);
      result.fold(
        (failure) {
          print(failure.errMessage);
          return errorMessage.value = failure.errMessage;
        },
        (paginatedData) {
          if (refresh) {
            purchaseOrders.value = paginatedData.content;
          } else {
            purchaseOrders.value = paginatedData.content;
          }

          totalPages.value = paginatedData.totalPages;
          totalElements.value = paginatedData.totalElements;
          hasNext.value = paginatedData.hasNext;
          hasPrevious.value = paginatedData.hasPrevious;
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      print(errorMessage.value.toString());
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
        final params = PaginationParams(
          page: currentPage.value,
          size: pageSize.value,
          languageCode: currentLanguageCode,
        );

        final result = await getAllPurchaseUseCase(params: params);
        result.fold(
          (failure) => errorMessage.value = failure.errMessage,
          (paginatedData) {
            purchaseOrders.addAll(paginatedData.content);
            totalPages.value = paginatedData.totalPages;
            totalElements.value = paginatedData.totalElements;
            hasNext.value = paginatedData.hasNext;
            hasPrevious.value = paginatedData.hasPrevious;
          },
        );
      } catch (e) {
        errorMessage.value = e.toString();
        print(errorMessage.value);
      } finally {
        isLoadingMore.value = false;
      }
    }
  }

  Future<void> refreshPurchaseOrders() async {
    try {
      isRefreshing.value = true;
      await Future.delayed(const Duration(milliseconds: 1500));
      getPurchaseOrders(refresh: true);
    } finally {
      isRefreshing.value = false;
    }
  }
}
