import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/entities/purchase_invoice_entity.dart';
import 'package:teriak/features/purchase_invoice/SearchPurchaseInvoice/domain/usecases/get_search_purchase_invoice.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/purchase_entity%20.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/controller/all_supplier_controller.dart';
import 'package:teriak/features/purchase_invoice/SearchPurchaseInvoice/data/datasources/search_purchase_invoice_remote_data_source.dart';
import 'package:teriak/features/purchase_invoice/SearchPurchaseInvoice/data/repositories/search_purchase_invoice_repository_impl.dart';

class SearchPurchaseInvoiceController extends GetxController {
   final supplierController = Get.find<GetAllSupplierController>();

  // Search state
 var isSearchingSupplier = false.obs;
var isSearchingDate = false.obs;

  var searchResults = <PurchaseInvoiceEntity>[].obs;
  var searchError = ''.obs;
  var hasSearchResults = false.obs;

  // Supplier search
  var supplierError = RxnString();
  var selectedSupplier = Rxn<SupplierModel>();

  // Date range search
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  var dateError = RxnString();

  // Pagination
  var currentPage = 0.obs;
  var totalPages = 0.obs;
  var totalElements = 0.obs;
  var hasNext = false.obs;
  var hasPrevious = false.obs;

  // Use cases
  late final GetSearchPurchaseInvoice searchBySupplierUseCase;
  late final GetSearchPurchaseInvoice searchByDateRangeUseCase;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);
    final networkInfo = NetworkInfoImpl(InternetConnection());

    final remoteDataSource =
        SearchPurchaseInvoiceRemoteDataSource(api: httpConsumer);
    final repository = SearchPurchaseInvoiceRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    searchBySupplierUseCase = GetSearchPurchaseInvoice(repository: repository);
    searchByDateRangeUseCase = GetSearchPurchaseInvoice(repository: repository);
  }

  void selectSupplier(SupplierModel supplier) {
    final existing = supplierController.suppliers.firstWhere(
      (s) => s.id == supplier.id,
      orElse: () => supplier,
    );
    selectedSupplier.value = existing;
    supplierError.value = null;
  }

  void setStartDate(DateTime date) {
    startDate.value = date;
    dateError.value = null;
  }

  void setEndDate(DateTime date) {
    endDate.value = date;
    dateError.value = null;
  }

 Future<void> searchBySupplier() async {
    if (selectedSupplier.value == null) {
      supplierError.value = 'Please select a supplier'.tr;
      return;
    }

    try {
      isSearchingSupplier.value = true;
      searchError.value = '';
      currentPage.value = 0;
      final languageCode = LocaleController.to.locale.languageCode;

      final params = SearchBySupplierParams(
        supplierId: selectedSupplier.value!.id,
        page: currentPage.value,
        size: 5,
        language: languageCode,
      );

      final result = await searchBySupplierUseCase.callBySupplier(params: params);
      result.fold(
        (failure) {
          searchError.value = failure.errMessage;
          hasSearchResults.value = false;
        },
        (paginatedResult) {
          searchResults.value = paginatedResult.content;
          totalPages.value = paginatedResult.totalPages;
          totalElements.value = paginatedResult.totalElements;
          hasNext.value = paginatedResult.hasNext;
          hasPrevious.value = paginatedResult.hasPrevious;
          hasSearchResults.value = true;
        },
      );
    } catch (e) {
      searchError.value = e.toString();
      hasSearchResults.value = false;
    } finally {
      isSearchingSupplier.value = false;
    }
  }

  Future<void> searchByDateRange() async {
    if (startDate.value == null || endDate.value == null) {
      dateError.value = 'Please select both start and end dates'.tr;
      return;
    }

    if (startDate.value!.isAfter(endDate.value!)) {
      dateError.value = 'Start date must be before end date'.tr;
      return;
    }

    try {
      isSearchingDate.value = true;
      searchError.value = '';
      currentPage.value = 0;
      final languageCode = LocaleController.to.locale.languageCode;

      final params = SearchByDateRangeParams(
        startDate: startDate.value!,
        endDate: endDate.value!,
        page: currentPage.value,
        size: 5,
        language: languageCode,
      );

      final result = await searchByDateRangeUseCase.callByDateRange(params: params);
      result.fold(
        (failure) {
          searchError.value = failure.errMessage;
          hasSearchResults.value = false;
        },
        (paginatedResult) {
          searchResults.value = paginatedResult.content;
          totalPages.value = paginatedResult.totalPages;
          totalElements.value = paginatedResult.totalElements;
          hasNext.value = paginatedResult.hasNext;
          hasPrevious.value = paginatedResult.hasPrevious;
          hasSearchResults.value = true;
        },
      );
    } catch (e) {
      searchError.value = e.toString();
      hasSearchResults.value = false;
    } finally {
      isSearchingDate.value = false;
    }
  }

 Future<void> loadNextPage() async {
  if (!hasNext.value) return;

  try {
    currentPage.value++;
    final languageCode = LocaleController.to.locale.languageCode;

    if (selectedSupplier.value != null) {
      if (isSearchingSupplier.value) return;
      isSearchingSupplier.value = true;

      final params = SearchBySupplierParams(
          supplierId: selectedSupplier.value!.id,
          page: currentPage.value,
          size: 5,
          language: languageCode);

      final result =
          await searchBySupplierUseCase.callBySupplier(params: params);
      result.fold(
        (failure) {
          searchError.value = failure.errMessage;
          currentPage.value--;
        },
        (paginatedResult) {
          searchResults.addAll(paginatedResult.content);
          hasNext.value = paginatedResult.hasNext;
        },
      );

      isSearchingSupplier.value = false;
    } 
    else if (startDate.value != null && endDate.value != null) {
      if (isSearchingDate.value) return;
      isSearchingDate.value = true;

      final params = SearchByDateRangeParams(
        startDate: startDate.value!,
        endDate: endDate.value!,
        page: currentPage.value,
        size: 5,
        language: languageCode,
      );

      final result = await searchByDateRangeUseCase.callByDateRange(params: params);
      result.fold(
        (failure) {
          searchError.value = failure.errMessage;
          currentPage.value--;
        },
        (paginatedResult) {
          searchResults.addAll(paginatedResult.content);
          hasNext.value = paginatedResult.hasNext;
        },
      );

      isSearchingDate.value = false;
    }
  } catch (e) {
    searchError.value = e.toString();
    currentPage.value--;
    isSearchingSupplier.value = false;
    isSearchingDate.value = false;
  }
}

  void clearSearch() {
    searchResults.clear();
    hasSearchResults.value = false;
    searchError.value = '';
    currentPage.value = 0;
    totalPages.value = 0;
    totalElements.value = 0;
    hasNext.value = false;
    hasPrevious.value = false;
  }

  void resetSearch() {
    selectedSupplier.value = null;
    startDate.value = null;
    endDate.value = null;
    supplierError.value = null;
    dateError.value = null;
    clearSearch();
  }
}