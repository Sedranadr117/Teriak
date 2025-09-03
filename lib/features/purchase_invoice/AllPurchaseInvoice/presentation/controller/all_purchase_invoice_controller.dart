import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/data/datasources/all_purchase_invoice._remote_data_source.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/data/repositories/all_purchase_invoice._repository_impl.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/usecases/get_all_purchase_invoice.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/purchase_model .dart';

class AllPurchaseInvoiceController extends GetxController {
  late final NetworkInfoImpl networkInfo;
  late final GetAllPurchaseInvoice getAllPurchaseInvoiceUseCase;

  // Variables for invoices
  var isLoadingInvoices = true.obs;
  var invoices = [].obs;
  var errorMessageInvoices = ''.obs;
  var isRefreshingInvoices = false.obs;

  // Variables for purchase orders (PENDING only)
  var isLoadingOrders = true.obs;
  var purchaseOrders = <PurchaseOrderModel>[].obs;
  var errorMessageOrders = ''.obs;
  var selectedOrderId = Rxn<int>();

  // Pagination variables for invoices
  var currentPage = 0.obs;
  var pageSize = 5.obs;
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

    final remoteDataSource =
        AllPurchaseInvoiceRemoteDataSource(api: httpConsumer);

    final repository = AllPurchaseInvoiceRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    getAllPurchaseInvoiceUseCase =
        GetAllPurchaseInvoice(repository: repository);
    getPurchaseInvoices();
  }

  void getPurchaseInvoices({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 0;
        isLoadingInvoices.value = true;
      } else {
        isLoadingInvoices.value = true;
      }

      String currentLanguageCode = LocaleController.to.locale.languageCode;
      final params = PaginationParams(
        page: currentPage.value,
        size: pageSize.value,
        languageCode: currentLanguageCode,
      );

      final result = await getAllPurchaseInvoiceUseCase(params: params);
      result.fold(
        (failure) {
          print(failure.errMessage);
          return errorMessageInvoices.value = failure.errMessage;
        },
        (paginatedData) {
          if (refresh) {
            invoices.value = paginatedData.content;
          } else {
            invoices.value = paginatedData.content;
          }

          totalPages.value = paginatedData.totalPages;
          totalElements.value = paginatedData.totalElements;
          hasNext.value = paginatedData.hasNext;
          hasPrevious.value = paginatedData.hasPrevious;
        },
      );
    } catch (e) {
      errorMessageInvoices.value = e.toString();
      print(errorMessageInvoices.value.toString());
    } finally {
      isLoadingInvoices.value = false;
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

        final result = await getAllPurchaseInvoiceUseCase(params: params);
        result.fold(
          (failure) => errorMessageInvoices.value = failure.errMessage,
          (paginatedData) {
            invoices.addAll(paginatedData.content);
            totalPages.value = paginatedData.totalPages;
            totalElements.value = paginatedData.totalElements;
            hasNext.value = paginatedData.hasNext;
            hasPrevious.value = paginatedData.hasPrevious;
          },
        );
      } catch (e) {
        errorMessageInvoices.value = e.toString();
        print(errorMessageInvoices.value);
      } finally {
        isLoadingMore.value = false;
      }
    }
  }

  Future<void> refreshPurchaseInvoices() async {
    try {
      isRefreshingInvoices.value = true;
      await Future.delayed(const Duration(milliseconds: 1500));
      getPurchaseInvoices(refresh: true);
    } finally {
      isRefreshingInvoices.value = false;
    }
  }

  // Select purchase order
  void selectPurchaseOrder(int orderId) {
    selectedOrderId.value = orderId;
  }

  // Clear errors
  void clearErrors() {
    errorMessageInvoices.value = '';
    errorMessageOrders.value = '';
  }
}
