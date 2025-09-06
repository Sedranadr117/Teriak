import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import 'package:teriak/features/stock_management/data/models/stock_model.dart';
import 'package:teriak/features/stock_management/domain/usecases/search_stock.dart';
import 'package:teriak/features/sales_management/domain/entities/refund_entity.dart';
import '../../../stock_management/data/repositories/stock_repository_impl.dart';

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
  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    selectedPaymentType = 'CASH'.obs;
    selectedPaymentMethod = 'CASH'.obs;
    discountController.text = '0';
    dueDateController.text = DateTime.now().toString();
    deferredAmountController.addListener(() {
      final value = double.tryParse(deferredAmountController.text) ?? 0.0;
      defferredAmount.value = value;
    });
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
    final stockRepository = StockRepositoryImpl(
      remoteDataSource: remoteDataSource1,
      networkInfo: networkInfo,
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
        Get.snackbar('Error'.tr, errorMessage.value);
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
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        errorMessage.value =
            'No internet connection. Please check your network.'.tr;
        Get.snackbar('Error'.tr, errorMessage.value);
        return;
      }
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
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        errorMessage.value =
            'No internet connection. Please check your network.'.tr;
        Get.snackbar('Error'.tr, errorMessage.value);
        return;
      }
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
        Get.snackbar('Error'.tr, errorMessage.value);
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
        invoiceItems[itemIndex] =
            invoiceItems[itemIndex].copyWith(quantity: newQuantity);
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

          resetSaleData();
          done = true;
        });
      } else {
        // أضف الفاتورة أوفلاين باستخدام Hive
        final hiveInvoice = HiveSaleInvoice.fromSaleParams(sale);
        print(
            '📦 Attempting to store offline invoice: ${hiveInvoice.toJson()}');

        final success =
            await repository.localDataSource.addInvoice(hiveInvoice);
        if (success) {
          print("✅ الفاتورة تخزنت أوفلاين");
          Get.snackbar('Success'.tr, 'تم تخزين الفاتورة أوفلاين');
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
    if (stockItem != null &&
        !cachedStockItems.any((item) => item.id == stockItem.id)) {
      cachedStockItems.add(stockItem);
      print('💾 Cached stock item: ${stockItem.productName}');
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
