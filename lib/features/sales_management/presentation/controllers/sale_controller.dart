import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/Sales_management/data/datasources/sale_remote_data_source.dart';
import 'package:teriak/features/Sales_management/data/repositories/sale_repository_impl.dart';
import 'package:teriak/features/Sales_management/domain/usecases/create_sale.dart';
import 'package:teriak/features/Sales_management/presentation/widgets/invoice_items_card.dart';
import 'package:teriak/features/customer_managment/presentation/controllers/customer_controller.dart';
import 'package:teriak/features/sales_management/data/models/invoice_model.dart';
import 'package:teriak/features/sales_management/domain/entities/invoice_entity.dart';
import 'package:teriak/features/sales_management/domain/usecases/get_invoices.dart';
import 'package:teriak/features/stock_management/data/models/Stock_model.dart';
import 'package:teriak/features/stock_management/domain/usecases/search_stock.dart';

class SaleController extends GetxController {
  final String customerTag;
  SaleController({required this.customerTag});
  final TextEditingController discountController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final RxList<InvoiceEntity> invoices = <InvoiceEntity>[].obs;

  RxString discountType = 'PERCENTAGE'.obs;
  late RxString selectedPaymentType;
  RxString selectedCurrency = 'SYP'.obs;

  DateTime? selectedDueDate;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  RxList<InvoiceItem> invoiceItems = <InvoiceItem>[].obs;
  final FocusNode searchFocusNode = FocusNode();
  RxList<String> searchHistory = <String>[].obs;

  RxDouble subtotal = 0.0.obs;
  RxDouble discountAmount = 0.0.obs;
  RxDouble total = 0.0.obs;
  final double taxAmount = 0.0;

  late final NetworkInfoImpl networkInfo;
  late final CreateSale _createSale;
  late final GetInvoices _getInvoices;
  late RxString selectedPaymentMethod;
  late CustomerController customerController;
  RxList<StockModel> results = <StockModel>[].obs;
  late final SearchStock _searchStock;
  final Rx<RxStatus?> searchStatus = Rx<RxStatus?>(null);

  bool done = false;
  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    customerController = Get.put(CustomerController());

    selectedPaymentType = 'CASH'.obs;
    selectedPaymentMethod = 'CASH'.obs;
    discountController.text = '0';
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    networkInfo = NetworkInfoImpl(InternetConnection());
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    final remoteDataSource = SaleRemoteDataSource(api: httpConsumer);

    final repository = SaleRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    _createSale = CreateSale(repository: repository);
    //_searchStock = SearchStock(repository: repository);

    _getInvoices = GetInvoices(repository: repository);
  }

  Future<void> refreshData() async {
    await fetchAllInvoices();
    Get.snackbar('', "Invoices refreshed successfully");
  }

  Future<void> fetchAllInvoices() async {
    print('fetchAllInvoicescalled');
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _getInvoices();
      result.fold((failure) {
        print('❌ Error fetching Invoices: ${failure.errMessage}');
        errorMessage.value = failure.errMessage;
        Get.snackbar('Error'.tr, errorMessage.value);
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

  Future<void> search(String query) async {
    try {
      isLoading.value = true;
      print('Search Status: Loading');
      errorMessage.value = '';
      final q = SearchParams(
        name: query.trim(),
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
          results.assignAll(list.map((entity) => StockModel()).toList());

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
    selectedCurrency.value = type;
  }

  void onCurrencyChanged(String currency) {
    selectedCurrency.value = currency;
  }

  void applyDiscount() {
    calculateTotals();
  }

  String getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
        return 'USD';
      case 'SYP':
        return 'SYP';
      default:
        return 'SYP';
    }
  }

  Future<void> createSale(List<SaleItemParams> items) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      print('🌐 Testing network connectivity...');
      final isConnected = await networkInfo.isConnected;
      print('📡 Network connected: $isConnected');
      if (!isConnected) {
        errorMessage.value =
            'No internet connection. Please check your network.'.tr;
        return;
      }
      final customerId = customerController.selectedCustomer.value?.id;
      if (customerId == null) {
        Get.snackbar("Error".tr, "Please select a customer first".tr);
        return;
      }
      final sale = SaleProcessParams(
          customerId: customerId,
          paymentType: selectedPaymentType.value,
          paymentMethod: selectedPaymentMethod.value,
          currency: selectedCurrency.value,
          discountType: discountType.value,
          discountValue: double.tryParse(discountController.text) ?? 0.0,
          items: items);
      final result = await _createSale(sale);
      result.fold((failure) {
        print(
            '❌ Error creating sale process for customer $customerId: ${failure.errMessage}');
        Get.snackbar('Error'.tr, 'Failed to create sale process'.tr);
        done = false;
      }, (addedSale) {
        print('✅ sale process added for customer $customerId');
        Get.snackbar('Success'.tr, 'sale process added successfully!'.tr);
        resetSaleData();
        done = true;
      });
    } catch (e) {
      print('❌ Exception adding sale process for customer : $e');
      Get.snackbar('Error'.tr, 'Failed to add sale process for customer.'.tr);
    } finally {
      isLoading.value = false;
    }
  }

//
  void addItemFromProduct(InvoiceItemModel product) {
    final existingItem =
        invoiceItems.firstWhereOrNull((item) => item.id == product.id);
    if (existingItem != null) {
      final index = invoiceItems.indexOf(existingItem);
      invoiceItems[index] =
          existingItem.copyWith(quantity: existingItem.quantity + 1);
    } else {
      invoiceItems.add(InvoiceItem(
        id: product.id,
        name: product.productName,
        quantity: 1,
        unitPrice: product.unitPrice,
        isPrescription: true,
      ));
    }
    invoiceItems.refresh();
    calculateTotals();
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
    selectedDueDate = null;

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
    super.dispose();
  }
}
