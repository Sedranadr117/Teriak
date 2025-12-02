import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:teriak/config/localization/locale_controller.dart';

import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/sales_management/data/models/hive_invoice_model.dart';
import 'package:teriak/features/sales_management/data/models/invoice_model.dart';
import 'package:teriak/features/sales_management/data/repositories/sale_repository_impl.dart';
import 'package:teriak/features/sales_management/domain/entities/invoice_entity.dart';
import 'package:teriak/features/sales_management/domain/usecases/create_sale.dart';
import 'package:teriak/features/sales_management/domain/usecases/get_invoices.dart';
import 'package:teriak/features/sales_management/domain/usecases/get_refunds.dart';
import 'package:teriak/features/sales_management/domain/usecases/search_by_range.dart';
import 'package:teriak/features/sales_management/domain/usecases/create_refund.dart';
import 'package:teriak/features/sales_management/presentation/widgets/invoice_items_card.dart';
import 'package:teriak/features/stock_management/data/datasources/Stock_remote_data_source.dart';
import 'package:teriak/features/stock_management/data/datasources/stock_local_data_source.dart';
import 'package:teriak/features/stock_management/data/models/hive_stock_model.dart';
import 'package:teriak/features/stock_management/data/models/stock_model.dart';
import 'package:teriak/features/stock_management/domain/usecases/search_stock.dart';
import 'package:teriak/features/sales_management/domain/entities/refund_entity.dart';
import '../../../stock_management/data/repositories/stock_repository_impl.dart';
import '../../../stock_management/presentation/controller/stock_controller.dart';
import '../../../stock_management/domain/entities/stock_entity.dart';

class SaleController extends GetxController {
  final String customerTag;
  SaleController({required this.customerTag});

  final TextEditingController discountController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController dateOfHireController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final RxList<InvoiceEntity> invoices = <InvoiceEntity>[].obs;
  RxDouble defferredAmount = 0.0.obs;
  final TextEditingController deferredAmountController =
      TextEditingController();

  RxString discountType = 'PERCENTAGE'.obs;
  late RxString selectedPaymentType;
  RxString selectedCurrency = 'SYP'.obs;
  var isSearching = false.obs;
  var isFilterActive = false.obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isSyncing = false.obs;
  final RxInt pendingSyncCount = 0.obs;
  RxList<InvoiceItem> invoiceItems = <InvoiceItem>[].obs;
  RxList<StockModel> cachedStockItems = <StockModel>[].obs;
  final FocusNode searchFocusNode = FocusNode();
  RxList<String> searchHistory = <String>[].obs;

  RxDouble subtotal = 0.0.obs;
  RxDouble discountAmount = 0.0.obs;
  RxDouble total = 0.0.obs;
  final double taxAmount = 0.0;
  var searchError = ''.obs;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();

  late final NetworkInfoImpl networkInfo;
  late final CreateSale _createSale;
  late final GetInvoices _getInvoices;
  late final SearchStock _searchStock;
  late final SearchByRange _searchByRange;
  late final GetRefundsUseCase _getRefunds;
  late final CreateRefund _createRefund;
  late RxString selectedPaymentMethod;

  RxList<StockModel> results = <StockModel>[].obs;
  final Rx<RxStatus?> searchStatus = Rx<RxStatus?>(null);
  var searchResults = <InvoiceEntity>[].obs;
  var refunds = <SaleRefundEntity>[].obs;
  final SaleRepositoryImpl repository = Get.find<SaleRepositoryImpl>();

  bool done = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _syncStatusTimer;
  bool _wasOffline = false;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    _startConnectivityMonitoring();
    _updatePendingSyncCount();
    selectedPaymentType = 'CASH'.obs;
    selectedPaymentMethod = 'CASH'.obs;
    discountController.text = '0';
    dueDateController.text = DateTime.now().toString();
    deferredAmountController.addListener(() {
      final value = double.tryParse(deferredAmountController.text) ?? 0.0;
      defferredAmount.value = value;
    });
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    _syncStatusTimer?.cancel();
    discountController.dispose();
    searchController.dispose();
    dateOfHireController.dispose();
    dueDateController.dispose();
    deferredAmountController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }

  /// Start monitoring connectivity changes to auto-sync offline invoices
  void _startConnectivityMonitoring() async {
    // Check initial connectivity state
    final initialConnectivity = await Connectivity().checkConnectivity();
    _wasOffline = initialConnectivity.contains(ConnectivityResult.none);

    // If we're already online on app start, check for offline invoices to sync
    if (!_wasOffline) {
      _updatePendingSyncCount();
      final offlineCount = pendingSyncCount.value;
      if (offlineCount > 0) {
        print('📦 Found $offlineCount offline invoice(s). Syncing...');
        // Delay slightly to ensure app is fully initialized
        Future.delayed(Duration(seconds: 1), () => _syncOfflineInvoices());
      }
    }

    // Periodically update pending count (every 5 seconds)
    _syncStatusTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      _updatePendingSyncCount();
    });

    // Listen for connectivity changes
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) async {
        final isNowOnline = !results.contains(ConnectivityResult.none);

        // If we were offline and now we're online, sync offline invoices
        if (_wasOffline && isNowOnline) {
          print('🔄 Connectivity restored! Auto-syncing offline invoices...');
          await _syncOfflineInvoices();
        }

        _wasOffline = !isNowOnline;
      },
    );
  }

  /// Manually trigger sync of offline invoices (can be called from UI)
  Future<void> manualSyncOfflineInvoices() async {
    if (isSyncing.value) {
      Get.snackbar('Info'.tr, 'Sync already in progress...'.tr);
      return;
    }
    await _syncOfflineInvoices();
  }

  /// Get count of offline invoices waiting to be synced
  int getOfflineInvoicesCount() {
    return repository.localDataSource.getOfflineInvoicesCount();
  }

  /// Update pending sync count observable
  void _updatePendingSyncCount() {
    pendingSyncCount.value = getOfflineInvoicesCount();
  }

  /// Public method to refresh sync status (can be called from UI)
  void refreshSyncStatus() {
    _updatePendingSyncCount();
  }

  /// Refresh stock cache after syncing offline invoices
  Future<void> _refreshStockAfterSync() async {
    try {
      final stockBox = Hive.box<HiveStockModel>('stockCache');
      final stockLocalDataSource = StockLocalDataSourceImpl(stockBox: stockBox);
      final httpConsumer = HttpConsumer(
        baseUrl: EndPoints.baserUrl,
        cacheHelper: CacheHelper(),
      );
      final stockRemoteDataSource = StockRemoteDataSource(api: httpConsumer);
      final networkInfo = NetworkInfoImpl();
      final stockRepository = StockRepositoryImpl(
        remoteDataSource: stockRemoteDataSource,
        networkInfo: networkInfo,
        localDataSource: stockLocalDataSource,
      );

      // Refresh stock from backend
      final result = await stockRepository.getStock();
      result.fold(
        (failure) => print(
            '⚠️ Failed to refresh stock after sync: ${failure.errMessage}'),
        (stocks) {
          print('✅ Refreshed stock after sync: ${stocks.length} items');
          // Automatically update StockController's list
          _updateStockControllerList(stocks);
        },
      );
    } catch (e) {
      print('❌ Error refreshing stock after sync: $e');
    }
  }

  /// Update StockController's list automatically from cache/backend
  void _updateStockControllerList(List<StockEntity> stocks) {
    try {
      // Try to find StockController and update its list
      if (Get.isRegistered<StockController>()) {
        final stockController = Get.find<StockController>();
        stockController.allStokes.assignAll(stocks);
        stockController.allStokes.refresh(); // Ensure UI updates
        stockController.allStockOriginal.assignAll(stocks);
        stockController.allStockOriginal.refresh(); // Ensure UI updates
        print(
            '🔄 Automatically updated StockController list: ${stocks.length} items');
      } else {
        print('ℹ️ StockController not registered, skipping auto-update');
      }

      // Also update search results and cached items in SaleController
      _updateSaleControllerStockLists(stocks);
    } catch (e) {
      print('⚠️ Could not update StockController automatically: $e');
    }
  }

  /// Update search results and cached items in SaleController after stock update
  void _updateSaleControllerStockLists(List<StockEntity> stocks) {
    try {
      // Convert StockEntity list to StockModel map for quick lookup
      final stockMap = <int, StockModel>{};
      for (final stock in stocks) {
        stockMap[stock.id] = StockModel.fromEntity(stock);
      }

      print('🔄 Updating ${stockMap.length} stock items in SaleController');
      print('📋 Current search results: ${results.length} items');
      print('💾 Current cached items: ${cachedStockItems.length} items');

      // Update search results if items match
      int updatedResultsCount = 0;
      for (int i = 0; i < results.length; i++) {
        final resultItem = results[i];
        if (stockMap.containsKey(resultItem.id)) {
          final oldQuantity = resultItem.totalQuantity;
          results[i] = stockMap[resultItem.id]!;
          updatedResultsCount++;
          print(
              '✅ Updated search result: ${resultItem.productName} (ID: ${resultItem.id}) - Quantity: $oldQuantity -> ${results[i].totalQuantity}');
        }
      }
      if (updatedResultsCount > 0) {
        results.refresh();
        print('🔄 Refreshed ${updatedResultsCount} search results');
      }

      // Update cached stock items
      int updatedCachedCount = 0;
      for (int i = 0; i < cachedStockItems.length; i++) {
        final cachedItem = cachedStockItems[i];
        if (stockMap.containsKey(cachedItem.id)) {
          final oldQuantity = cachedItem.totalQuantity;
          cachedStockItems[i] = stockMap[cachedItem.id]!;
          updatedCachedCount++;
          print(
              '✅ Updated cached item: ${cachedItem.productName} (ID: ${cachedItem.id}) - Quantity: $oldQuantity -> ${cachedStockItems[i].totalQuantity}');
        }
      }
      if (updatedCachedCount > 0) {
        cachedStockItems.refresh();
        print('🔄 Refreshed ${updatedCachedCount} cached items');
      }

      // If there's an active search query, refresh the search to get updated results
      if (searchController.text.trim().isNotEmpty) {
        print('🔍 Active search query detected, refreshing search...');
        // Re-run the search to get updated results
        search(searchController.text.trim());
      }

      print('✅ Completed updating SaleController stock lists');
    } catch (e) {
      print('⚠️ Could not update SaleController stock lists: $e');
    }
  }

  /// Validate stock availability for offline sales
  /// Returns null if validation passes, or error message if validation fails
  Future<String?> _validateOfflineStockAvailability(
      List<SaleItemParams> items) async {
    try {
      final stockBox = Hive.box<HiveStockModel>('stockCache');
      final stockLocalDataSource = StockLocalDataSourceImpl(stockBox: stockBox);

      // Get all cached stocks
      final cachedStocks = stockLocalDataSource.getStocks();

      if (cachedStocks.isEmpty) {
        return 'No stock data available offline. Please connect to internet to load stock data first.'
            .tr;
      }

      // Check each item in the sale
      final validationErrors = <String>[];

      for (final item in items) {
        // Find the stock item in cache
        final stock = cachedStocks.firstWhereOrNull(
          (s) => s.id == item.stockItemId,
        );

        if (stock == null) {
          // Try to find by product name from invoiceItems
          final invoiceItem = invoiceItems.firstWhereOrNull(
            (invItem) => invItem.id == item.stockItemId,
          );
          final productName =
              invoiceItem?.name ?? 'Product ID ${item.stockItemId}';

          validationErrors.add(
            'Product "$productName" (ID: ${item.stockItemId}) is not available in stock.'
                .tr,
          );
          print(
              '❌ Stock validation failed: Product ID ${item.stockItemId} not found in cache');
          continue;
        }

        // Check if quantity is sufficient
        final availableQuantity = stock.totalQuantity as num?;
        final requestedQuantity = item.quantity;

        if (availableQuantity == null ||
            availableQuantity < requestedQuantity) {
          validationErrors.add(
            'Insufficient stock for "${stock.productName}". Available: ${availableQuantity ?? 0}, Requested: $requestedQuantity'
                .tr,
          );
          print(
              '❌ Stock validation failed: ${stock.productName} - Available: $availableQuantity, Requested: $requestedQuantity');
        } else {
          print(
              '✅ Stock validation passed: ${stock.productName} - Available: $availableQuantity, Requested: $requestedQuantity');
        }
      }

      if (validationErrors.isNotEmpty) {
        return validationErrors.join('\n');
      }

      return null; // Validation passed
    } catch (e) {
      print('❌ Error validating stock availability: $e');
      return 'Error validating stock availability: $e'.tr;
    }
  }

  /// Update stock after a sale operation
  /// - Online: Refresh stock from backend (backend already updated quantities)
  /// - Offline: Reduce quantities in local cache
  Future<void> _updateStockAfterSale(List<SaleItemParams> items,
      {bool isOffline = false}) async {
    try {
      if (isOffline) {
        // For offline sales: reduce quantities in local cache
        final stockBox = Hive.box<HiveStockModel>('stockCache');
        final stockLocalDataSource =
            StockLocalDataSourceImpl(stockBox: stockBox);

        // Create map of stock ID to quantity to reduce
        final stockIdToQuantity = <int, int>{};
        for (final item in items) {
          print(
              '📦 Offline sale item: stockItemId=${item.stockItemId}, quantity=${item.quantity}');
          stockIdToQuantity[item.stockItemId] =
              (stockIdToQuantity[item.stockItemId] ?? 0) + item.quantity;
        }

        print(
            '🔄 Reducing stock quantities for ${stockIdToQuantity.length} items');
        await stockLocalDataSource.reduceStockQuantities(stockIdToQuantity);
        print('📉 Updated stock quantities in cache for offline sale');

        // Automatically update StockController's list from cache
        final updatedStocks = stockLocalDataSource.getStocks();
        print('📊 Retrieved ${updatedStocks.length} updated stocks from cache');

        // Verify the updates by checking a few items
        for (final entry in stockIdToQuantity.entries) {
          final updatedStock =
              updatedStocks.firstWhereOrNull((s) => s.id == entry.key);
          if (updatedStock != null) {
            print(
                '✅ Stock ID ${entry.key}: quantity is now ${updatedStock.totalQuantity}');
          } else {
            print('⚠️ Stock ID ${entry.key} not found in updated stocks list');
          }
        }

        _updateStockControllerList(updatedStocks);
      } else {
        // For online sales: refresh stock from backend (backend already updated it)
        final stockBox = Hive.box<HiveStockModel>('stockCache');
        final stockLocalDataSource =
            StockLocalDataSourceImpl(stockBox: stockBox);
        final httpConsumer = HttpConsumer(
          baseUrl: EndPoints.baserUrl,
          cacheHelper: CacheHelper(),
        );
        final stockRemoteDataSource = StockRemoteDataSource(api: httpConsumer);
        final networkInfo = NetworkInfoImpl();
        final stockRepository = StockRepositoryImpl(
          remoteDataSource: stockRemoteDataSource,
          networkInfo: networkInfo,
          localDataSource: stockLocalDataSource,
        );

        // Refresh stock from backend
        final result = await stockRepository.getStock();
        result.fold(
          (failure) => print(
              '⚠️ Failed to refresh stock after sale: ${failure.errMessage}'),
          (stocks) {
            print('✅ Refreshed stock after sale: ${stocks.length} items');
            // Automatically update StockController's list
            _updateStockControllerList(stocks);
          },
        );
      }
    } catch (e) {
      print('❌ Error updating stock after sale: $e');
    }
  }

  /// Sync offline invoices to backend
  Future<void> _syncOfflineInvoices() async {
    isSyncing.value = true;
    try {
      _updatePendingSyncCount();
      final result = await repository.syncOfflineInvoices();
      result.fold(
        (failure) {
          print('❌ Failed to sync offline invoices: ${failure.errMessage}');
          Get.snackbar(
            'Sync Error'.tr,
            'Failed to sync some offline invoices. They will be synced later.'
                .tr,
            duration: Duration(seconds: 3),
          );
        },
        (syncedInvoices) {
          if (syncedInvoices.isNotEmpty) {
            print(
                '✅ Successfully synced ${syncedInvoices.length} offline invoice(s)');
            Get.snackbar(
              'Sync Success'.tr,
              '${syncedInvoices.length} offline invoice(s) synced successfully!'
                  .tr,
              duration: Duration(seconds: 2),
            );

            // Refresh stock after syncing invoices (backend updated stock)
            _refreshStockAfterSync();
          } else {
            print('ℹ️ No offline invoices to sync');
          }
        },
      );
      _updatePendingSyncCount();
    } catch (e) {
      print('❌ Error during auto-sync: $e');
    } finally {
      isSyncing.value = false;
    }
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    networkInfo = NetworkInfoImpl();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    _createSale = CreateSale(repository: repository);
    _getInvoices = GetInvoices(repository: repository);
    _searchByRange = SearchByRange(repository: repository);
    _getRefunds = GetRefundsUseCase(repository: repository);
    _createRefund = CreateRefund(repository: repository);

    final remoteDataSource1 = StockRemoteDataSource(api: httpConsumer);
    final localDataSource = StockLocalDataSourceImpl(
        stockBox: Hive.box<HiveStockModel>('stockCache'));
    final stockRepository = StockRepositoryImpl(
      remoteDataSource: remoteDataSource1,
      networkInfo: networkInfo,
      localDataSource: localDataSource,
    );
    _searchStock = SearchStock(repository: stockRepository);
  }

  Future<void> createRefund({
    required int saleInvoiceId,
    required List<RefundItemParams> items,
    required String refundReason,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        errorMessage.value =
            'No internet connection. Please check your network.'.tr;
        // Get.snackbar('Error'.tr, errorMessage.value);
        return;
      }

      final params =
          SaleRefundParams(refundItems: items, refundReason: refundReason);
      final result =
          await _createRefund(saleInvoiceId: saleInvoiceId, params: params);
      result.fold((failure) {
        errorMessage.value = failure.errMessage;
        Get.snackbar('Error'.tr, errorMessage.value);
        done = false;
      }, (refund) {
        Get.snackbar('Success'.tr, 'Refund created successfully!'.tr);
        done = true;
        Get.toNamed(AppPages.showInvoices);
      });
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error'.tr, 'Failed to create refund'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectDueDate(
      {required DateTime initialDate, required BuildContext context}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      dueDateController.text = picked.toIso8601String().split('T')[0];
    }
  }

  Future<void> refreshData() async {
    await fetchAllInvoices();
  }

  Future<void> refreshRefund() async {
    await fetchRefunds();
  }

  Future<void> searchByDateRange() async {
    if (startDate.value == null || endDate.value == null) {
      errorMessage.value = 'Please select both start and end dates'.tr;
      Get.snackbar('Error'.tr, errorMessage.value);
      return;
    }

    if (startDate.value!.isAfter(endDate.value!)) {
      errorMessage.value = 'Start date must be before end date'.tr;
      Get.snackbar('Error'.tr, errorMessage.value);
      return;
    }

    isLoading.value = true;
    isSearching.value = true;
    isFilterActive.value = true;
    searchResults.clear();
    searchError.value = '';
    errorMessage.value = '';

    try {
      // final wasConnected = await networkInfo.isConnected;
      final params = SearchInvoiceByDateRangeParams(
        startDate: startDate.value!,
        endDate: endDate.value!,
      );

      final result = await _searchByRange(params: params);
      result.fold(
        (failure) {
          if (failure.statusCode == 404) {
            errorMessage.value = "No invoices found";
            Get.snackbar('Error'.tr, errorMessage.value);
          } else if (failure.statusCode == 500) {
            errorMessage.value =
                'An unexpected error occurred. Please try again.'.tr;
            Get.snackbar('Error'.tr, errorMessage.value);
          } else {
            errorMessage.value = failure.errMessage;
            Get.snackbar('Errors'.tr, errorMessage.value);
          }
        },
        (result) {
          searchResults.value = result;
          if (result.isEmpty) {
            searchError.value = 'No invoices found for this date range'.tr;
          }
          // if (!wasConnected) {
          //   Get.snackbar(
          //     'Offline mode'.tr,
          //     'Showing cached invoices for the selected range.'.tr,
          //   );
          // }
        },
      );
    } catch (e) {
      searchError.value = e.toString();
    } finally {
      isLoading.value = false;
      isSearching.value = false;
    }
  }

  Future<void> fetchAllInvoices() async {
    print('fetchAllInvoicescalled');
    isLoading.value = true;
    errorMessage.value = '';
    try {
      // final wasConnected = await networkInfo.isConnected;
      final result = await _getInvoices();
      result.fold((failure) {
        print('❌ Error fetching Invoices: ${failure.errMessage}');
        if (failure.statusCode == 500) {
          errorMessage.value =
              'An unexpected error occurred. Please try again.'.tr;
          Get.snackbar(
            'Error'.tr,
            errorMessage.value,
          );
        } else {
          errorMessage.value = failure.errMessage;
          Get.snackbar('Errors'.tr, errorMessage.value);
        }
      }, (invoicesList) {
        print('✅ Invoices fetched: ${invoicesList.length}');

        invoices.assignAll(invoicesList);
        // if (!wasConnected) {
        //   Get.snackbar('Offline mode'.tr, 'Showing cached invoices.'.tr);
        // }
      });
    } catch (e) {
      print('💥 Unexpected error while fetching invoices: $e');
      errorMessage.value = 'An unexpected error occurred. Please try again.'.tr;
      Get.snackbar('Error'.tr, errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRefunds() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        errorMessage.value =
            'No internet connection. Please check your network.'.tr;
        // Get.snackbar('Error'.tr, errorMessage.value);
        return;
      }
      final result = await _getRefunds();
      result.fold((failure) {
        print('❌ Error fetching refund: ${failure.errMessage}');
        if (failure.statusCode == 500) {
          errorMessage.value =
              'An unexpected error occurred. Please try again.'.tr;
          Get.snackbar(
            'Error'.tr,
            errorMessage.value,
          );
        } else {
          errorMessage.value = failure.errMessage;
          Get.snackbar('Errors'.tr, errorMessage.value);
        }
      }, (data) {
        refunds.assignAll(data);
      });
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred. Please try again.'.tr;
      Get.snackbar('Error'.tr, errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> search(String query) async {
    try {
      isLoading.value = true;
      isSearching.value = true;
      final languageCode = LocaleController.to.locale.languageCode;

      print('Search Status: Loading');
      errorMessage.value = '';
      final q = SearchStockParams(
        keyword: query.trim(),
        lang: languageCode,
      );
      print('Searching for: $query');

      final result = await _searchStock(params: q);
      result.fold(
        (failure) {
          results.clear();
          errorMessage.value = failure.errMessage;
          searchStatus.value = RxStatus.error(failure.errMessage);
          print('Search Error: ${failure.errMessage}');
        },
        (list) {
          results.clear();
          results.assignAll(list.map((e) => StockModel.fromEntity(e)).toList());
          print('Search Results: ${results.length} items');
          if (list.isEmpty) {
            results.clear();
            searchStatus.value = RxStatus.empty();
            print('Search Status: Empty Results');
          } else {
            searchStatus.value = RxStatus.success();
          }
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      searchStatus.value = RxStatus.error(e.toString());
      print('Search Status: Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
      isSearching.value = false;
    }
  }

  void calculateTotals() {
    subtotal.value = invoiceItems.fold(0.0, (sum, item) => sum + item.total);

    if (discountType.value == 'PERCENTAGE') {
      discountAmount.value = subtotal.value *
          (double.tryParse(discountController.text) ?? 0.0) /
          100;
    } else {
      discountAmount.value = double.tryParse(discountController.text) ?? 0.0;
    }

    double discountedSubtotal = subtotal.value - discountAmount.value;
    total.value = discountedSubtotal + taxAmount;
  }

  void updateItemQuantity(int itemId, int newQuantity) {
    final itemIndex = invoiceItems.indexWhere((item) => item.id == itemId);
    if (itemIndex != -1) {
      if (newQuantity <= 0) {
        invoiceItems.removeAt(itemIndex);
      } else {
        // Check available stock before updating quantity
        final item = invoiceItems[itemIndex];
        final stockItem = cachedStockItems.firstWhereOrNull(
          (stock) => stock.id == itemId,
        );

        // Also check in results if not in cached items
        final stockFromResults = stockItem ??
            results.firstWhereOrNull((stock) => stock.id == itemId);

        if (stockFromResults != null) {
          final availableQuantity = stockFromResults.totalQuantity as num?;
          if (availableQuantity != null && newQuantity > availableQuantity) {
            Get.snackbar(
              'Insufficient Stock'.tr,
              'Available quantity for "${item.name}" is $availableQuantity. You cannot sell more than available stock.'
                  .tr,
              duration: Duration(seconds: 3),
            );
            // Set quantity to available quantity instead
            invoiceItems[itemIndex] = invoiceItems[itemIndex]
                .copyWith(quantity: availableQuantity.toInt());
          } else {
            invoiceItems[itemIndex] =
                invoiceItems[itemIndex].copyWith(quantity: newQuantity);
          }
        } else {
          // If stock not found in cache, check from StockController
          if (Get.isRegistered<StockController>()) {
            try {
              final stockController = Get.find<StockController>();
              final stockEntity = stockController.allStokes.firstWhereOrNull(
                (stock) => stock.id == itemId,
              );

              if (stockEntity != null) {
                final availableQuantity = stockEntity.totalQuantity as num?;
                if (availableQuantity != null &&
                    newQuantity > availableQuantity) {
                  Get.snackbar(
                    'Insufficient Stock'.tr,
                    'Available quantity for "${item.name}" is $availableQuantity. You cannot sell more than available stock.'
                        .tr,
                    duration: Duration(seconds: 3),
                  );
                  invoiceItems[itemIndex] = invoiceItems[itemIndex]
                      .copyWith(quantity: availableQuantity.toInt());
                } else {
                  invoiceItems[itemIndex] =
                      invoiceItems[itemIndex].copyWith(quantity: newQuantity);
                }
              } else {
                // Stock not found, allow the update but warn
                print(
                    '⚠️ Stock item ID $itemId not found in cache or StockController');
                invoiceItems[itemIndex] =
                    invoiceItems[itemIndex].copyWith(quantity: newQuantity);
              }
            } catch (e) {
              print('⚠️ Error checking stock: $e');
              invoiceItems[itemIndex] =
                  invoiceItems[itemIndex].copyWith(quantity: newQuantity);
            }
          } else {
            // StockController not available, allow update but warn
            print('⚠️ StockController not registered, cannot validate stock');
            invoiceItems[itemIndex] =
                invoiceItems[itemIndex].copyWith(quantity: newQuantity);
          }
        }
      }
    }

    calculateTotals();
  }

  void onPaymentTypeChanged(String type) {
    selectedPaymentType.value = type;
  }

  Future<void> createSaleOffline(HiveSaleInvoice invoice) async {
    await repository.localDataSource.addInvoice(invoice);
  }

  void onCurrencyChanged(String currency) {
    selectedCurrency.value = currency;
    updateItemPricesForCurrency();
  }

  void updateItemPricesForCurrency() {
    for (int i = 0; i < invoiceItems.length; i++) {
      final item = invoiceItems[i];
      final stockItem =
          cachedStockItems.firstWhereOrNull((stock) => stock.id == item.id);
      if (stockItem != null) {
        final newPrice = selectedCurrency.value == 'USD'
            ? stockItem.sellingPriceUSD
            : stockItem.sellingPrice;
        invoiceItems[i] = item.copyWith(unitPrice: newPrice);
      } else {
        print(
            '❌ Could not find cached stock item for ${item.name} (ID: ${item.id})');
      }
    }
    invoiceItems.refresh();
    calculateTotals();
  }

  void applyDiscount() {
    calculateTotals();
  }

  String getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
        return '\$';
      case 'SYP':
        return 'Sp';
      default:
        return 'Sp';
    }
  }

  Future<void> createSale(List<SaleItemParams> items, int? customerId) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      String? dueDate;
      if (selectedPaymentType.value == "CREDIT" &&
          dueDateController.text.isNotEmpty) {
        final date = DateTime.tryParse(dueDateController.text);
        if (date != null) {
          dueDate = date.toIso8601String().split('T').first;
        }
      }

      final sale = SaleProcessParams(
          debtDueDate: dueDate,
          customerId: customerId,
          paymentType: selectedPaymentType.value,
          paymentMethod: selectedPaymentMethod.value,
          currency: selectedCurrency.value,
          discountType: discountType.value,
          discountValue: double.tryParse(discountController.text) ?? 0.0,
          items: items,
          paidAmount: selectedPaymentType.value == "CREDIT"
              ? defferredAmount.value
              : total.value);
      final connected = await networkInfo.isConnected;

      if (connected) {
        final result = await _createSale(sale);
        result.fold((failure) {
          if (failure.statusCode == 400 &&
              failure.errMessage.contains('Insufficient stock')) {
            final match = RegExp(
                    r'product: (.+) \(ID: (\d+)\)\. Available: (\d+), Requested: (\d+)')
                .firstMatch(failure.errMessage);

            if (match != null) {
              final productName = match.group(1);
              final available = match.group(3);
              final requested = match.group(4);
              errorMessage.value = '⚠️ Cannot add product'.tr +
                  " $productName " +
                  'Available quantity:'.tr +
                  ' $available '.tr +
                  ', Requested:'.tr +
                  ' $requested. ';
            } else {
              errorMessage.value =
                  '⚠️ There is an error in adding the products. Please check the quantity.'
                      .tr;
            }

            Get.snackbar(
              'Error'.tr,
              errorMessage.value,
            );
          } else if (failure.statusCode == 500) {
            errorMessage.value =
                'An unexpected error occurred. Please try again.'.tr;
            Get.snackbar(
              'Error'.tr,
              errorMessage.value,
            );
          } else {
            errorMessage.value = '⚠️ فشل في معالجة العملية. الرجاء المحاولة.';
            Get.snackbar(
              'خطأ',
              errorMessage.value,
            );
          }

          done = false;
        }, (addedSale) {
          print('✅ sale process added for customer $customerId');

          Get.snackbar('Success'.tr, 'sale process added successfully!'.tr);

          // Update stock after successful sale
          _updateStockAfterSale(items);

          resetSaleData();
          done = true;
        });
      } else {
        // Validate stock availability before processing offline sale
        print('🔍 Validating stock availability for offline sale...');
        final validationError = await _validateOfflineStockAvailability(items);

        if (validationError != null) {
          errorMessage.value = validationError;
          Get.snackbar(
            'Stock Validation Error'.tr,
            validationError,
            duration: Duration(seconds: 4),
          );
          done = false;
          return;
        }

        print('✅ Stock validation passed, proceeding with offline sale');

        // أضف الفاتورة أوفلاين باستخدام Hive
        // Create map of product IDs to names from invoiceItems
        final productNames = <int, String>{};
        for (final item in invoiceItems) {
          productNames[item.id] = item.name;
        }

        final hiveInvoice = HiveSaleInvoice.fromSaleParams(
          sale,
          productNames: productNames,
        );
        print(
            '📦 Attempting to store offline invoice: ${hiveInvoice.toJson()}');

        final success =
            await repository.localDataSource.addInvoice(hiveInvoice);
        if (success) {
          print("✅ الفاتورة تخزنت أوفلاين");
          Get.snackbar('Success'.tr, 'sale process added successfully!'.tr);

          // Update stock quantities in cache for offline sale (await to ensure it completes)
          await _updateStockAfterSale(items, isOffline: true);

          // Update pending sync count
          _updatePendingSyncCount();

          resetSaleData();
          done = true;
        } else {
          errorMessage.value = '❌ خطأ بتخزين الفاتورة أوفلاين'.tr;
          Get.snackbar('Error'.tr, errorMessage.value);
          print(errorMessage.value);
        }
      }
    } catch (e) {
      print('❌ Exception adding sale process for customer : $e');
      print(customerId);
      Get.snackbar('Error'.tr, 'Failed to add sale process for customer.'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  void addItemFromProduct(InvoiceItemModel product) {
    print(
        '💰 Controller Debug: Adding ${product.productName}, Price=${product.unitPrice}, Currency=${selectedCurrency.value}');
    final stockItem =
        results.firstWhereOrNull((stock) => stock.id == product.id);

    // Check if product exists in stock
    if (stockItem == null) {
      // Try to find in cached items
      final cachedItem = cachedStockItems.firstWhereOrNull(
        (item) => item.id == product.id,
      );

      if (cachedItem == null) {
        // Try to find in StockController
        if (Get.isRegistered<StockController>()) {
          try {
            final stockController = Get.find<StockController>();
            final stockEntity = stockController.allStokes.firstWhereOrNull(
              (stock) => stock.id == product.id,
            );

            if (stockEntity == null) {
              Get.snackbar(
                'Product Not Available'.tr,
                'Product "${product.productName}" is not available in stock.'
                    .tr,
                duration: Duration(seconds: 3),
              );
              print(
                  '❌ Product ${product.productName} (ID: ${product.id}) not found in stock');
              return;
            }
          } catch (e) {
            print('⚠️ Error checking stock: $e');
            Get.snackbar(
              'Error'.tr,
              'Could not verify stock availability. Please try again.'.tr,
              duration: Duration(seconds: 2),
            );
            return;
          }
        } else {
          Get.snackbar(
            'Product Not Available'.tr,
            'Product "${product.productName}" is not available in stock.'.tr,
            duration: Duration(seconds: 3),
          );
          print(
              '❌ Product ${product.productName} (ID: ${product.id}) not found in stock');
          return;
        }
      }
    }

    if (stockItem != null &&
        !cachedStockItems.any((item) => item.id == stockItem.id)) {
      cachedStockItems.add(stockItem);
      print('💾 Cached stock item: ${stockItem.productName}');
    }

    // Check available quantity before adding
    final availableQuantity = stockItem?.totalQuantity ??
        cachedStockItems
            .firstWhereOrNull((item) => item.id == product.id)
            ?.totalQuantity;

    if (availableQuantity != null && (availableQuantity as num) <= 0) {
      Get.snackbar(
        'Out of Stock'.tr,
        'Product "${product.productName}" is out of stock.'.tr,
        duration: Duration(seconds: 3),
      );
      print(
          '❌ Product ${product.productName} is out of stock (quantity: $availableQuantity)');
      return;
    }

    invoiceItems.add(InvoiceItem(
      id: product.id,
      name: product.productName,
      quantity: 1,
      unitPrice: product.unitPrice,
    ));

    invoiceItems.refresh();
    calculateTotals();
  }

  double getSellingPriceForCurrency(InvoiceItemModel product) {
    final stockItem =
        results.firstWhereOrNull((stock) => stock.id == product.id);
    if (stockItem != null) {
      return selectedCurrency.value == 'USD'
          ? stockItem.sellingPriceUSD
          : stockItem.sellingPrice;
    }
    return product.unitPrice;
  }

  void onPaymentMethodSelected(String method) {
    selectedPaymentMethod.value = method;
    errorMessage.value = '';
  }

  void resetSaleData() {
    print("🔄 Resetting sale data...");
    discountController.text = '0';
    searchController.clear();

    discountType.value = 'PERCENTAGE';
    selectedPaymentType.value = 'CASH';
    selectedPaymentMethod.value = 'CASH';
    selectedCurrency.value = 'SYP';

    invoiceItems.clear();
    subtotal.value = 0.0;
    discountAmount.value = 0.0;
    total.value = 0.0;

    searchHistory.clear();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    deferredAmountController.dispose();
    super.dispose();
  }
}
