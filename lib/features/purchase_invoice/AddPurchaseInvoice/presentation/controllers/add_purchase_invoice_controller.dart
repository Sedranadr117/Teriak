import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/purchase_invoice/AddPurchaseInvoice/data/datasources/add_purchase_invoice_remote_data_source.dart';
import 'package:teriak/features/purchase_invoice/AddPurchaseInvoice/data/repositories/add_purchase_invoice_repository_impl.dart';
import 'package:teriak/features/purchase_invoice/AddPurchaseInvoice/domain/usecases/post_add_purchase_invoice.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/purchase_model .dart';

class AddPurchaseInvoiceController extends GetxController {
  final _formKey = GlobalKey<FormState>();
  final _invoiceNumberController = TextEditingController();
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Observable variables
  final Rx<PurchaseOrderModel?> _purchaseOrder = Rx<PurchaseOrderModel?>(null);
  final RxList<Map<String, dynamic>> _products = <Map<String, dynamic>>[].obs;
  final RxBool _isSaving = false.obs;
  final RxString _searchQuery = ''.obs;
  final RxBool _hasUnsavedChanges = false.obs;
  final RxString errorMessage = ''.obs;

  // Getters
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get invoiceNumberController => _invoiceNumberController;
  TextEditingController get searchController => _searchController;
  ScrollController get scrollController => _scrollController;
  PurchaseOrderModel? get purchaseOrder => _purchaseOrder.value;
  List<Map<String, dynamic>> get products => _products;
  bool get isSaving => _isSaving.value;
  String get searchQuery => _searchQuery.value;
  bool get hasUnsavedChanges => _hasUnsavedChanges.value;

  late final NetworkInfoImpl networkInfo;

  late final AddPurchaseInvoice addPurchaseInvoiceUseCase;

  @override
  void onInit() {
    super.onInit();
    _initDependencies();
  }

  void _initDependencies() {
    final cacheHelper = CacheHelper();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);
    networkInfo = NetworkInfoImpl();
    final remoteDataSource =
        AddPurchaseInvoiceRemoteDataSource(api: httpConsumer);
    final repository = AddPurchaseInvoiceRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    addPurchaseInvoiceUseCase = AddPurchaseInvoice(repository: repository);
  }

  @override
  void onClose() {
    _invoiceNumberController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.onClose();
  }

  void setPurchaseOrder(PurchaseOrderModel po) {
    _purchaseOrder.value = po;
    _generateProductsFromPO(po);
  }

  void _generateProductsFromPO(PurchaseOrderModel po) {
    final List<Map<String, dynamic>> products = po.items
        .map((item) => {
              "id": item.id,
              "name": item.productName,
              "productId": item.productId,
              "barcode": item.barcode,
              "requiredQuantity": item.quantity,
              "invoicePrice": item.price,
              "sellingPrice": item.refSellingPrice,
              "receivedQty": 0,
              "bonusQty": 0,
              "minStockLevel": item.minStockLevel,
              "batchNo": "",
              "expiryDate": null,
              "actualPrice": 0.0,
              "isSelected": false,
              "productType": item.productType
            })
        .toList();

    _products.assignAll(products);

    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    try {
      for (int i = 0; i < _products.length; i++) {
        final product = _products[i];
        final productId = product['productId'];

        if (product['productType'] == 'PHARMACY' ||
            product['productType'] == 'صيدلية') {
          _products[i]['sellingPrice'];
          _products[i]['minStockLevel'];
        }
      }

      _products.refresh();
    } catch (e) {
      print('Error fetching product details: $e');
    }
  }

  void onSearchChanged(String query) {
    _searchQuery.value = query;

    if (query.isNotEmpty) {
      _scrollToMatchingProduct(query);
    }
  }

  void _scrollToMatchingProduct(String query) {
    for (int i = 0; i < _products.length; i++) {
      final product = _products[i];
      if (product['name'].contains(query) ||
          product['barcode'].contains(query)) {
        final position = i * 120.0;
        _scrollController.animateTo(
          position,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        break;
      }
    }
  }

  void onBarcodeScanned(String barcode) {
    _searchController.text = barcode;
    onSearchChanged(barcode);

    for (int i = 0; i < _products.length; i++) {
      if (_products[i]['barcode'] == barcode) {
        _scrollToMatchingProduct(barcode);
        break;
      }
    }
  }

  void onProductDataChanged(int index, Map<String, dynamic> updatedData) {
    _products[index] = {..._products[index], ...updatedData};

    _updateActualPrice(index);

    _hasUnsavedChanges.value = true;
  }

  void _updateActualPrice(int index) {
    final product = _products[index];
    final receivedQty = product['receivedQty'] as int;
    final bonusQty = product['bonusQty'] as int;
    final invoicePrice = product['invoicePrice'] as double;

    if (receivedQty > 0) {
      final totalQty = receivedQty + bonusQty;
      final actualPrice =
          totalQty > 0 ? (receivedQty * invoicePrice) / totalQty : invoicePrice;

      _products[index]['actualPrice'] = actualPrice;
    } else {
      _products[index]['actualPrice'] = invoicePrice;
    }

    _products.refresh();
  }

  double calculateTotalAmount() {
    double total = 0.0;
    for (final product in _products) {
      final receivedQty = product['receivedQty'] as int;
      final bonusQty = product['bonusQty'] as int;
      final invoicePrice = product['invoicePrice'] as double;

      if (receivedQty > 0) {
        final totalQty = receivedQty + bonusQty;
        final actualPrice = totalQty > 0
            ? (receivedQty * invoicePrice) / totalQty
            : invoicePrice;
        total += totalQty * actualPrice;
      }
    }
    return total;
  }

  int getTotalReceivedItems() {
    return _products.fold(
        0, (sum, product) => sum + (product['receivedQty'] as int));
  }

  int getTotalBonusItems() {
    return _products.fold(
        0, (sum, product) => sum + (product['bonusQty'] as int));
  }

  bool validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    final hasReceivedProducts =
        _products.any((product) => (product['receivedQty'] as int) > 0);
    if (!hasReceivedProducts) {
      return false;
    }

    return true;
  }

  String mapProductType(String type) {
    switch (type) {
      case "صيدلية":
      case "Pharmacy":
        return "Pharmacy".toUpperCase();
      case "مركزي":
      case "Master":
        return "Master".toUpperCase();
      default:
        throw Exception("Unknown productType: $type");
    }
  }

  Future<void> saveInvoice() async {
    if (!validateForm()) {
      return;
    }
    _isSaving.value = true;

    try {
      await Future.delayed(const Duration(seconds: 2));
      final List<Map<String, dynamic>> items =
          _products.where((p) => (p['receivedQty'] ?? 0) > 0).map((p) {
        print(p["productType"]);
        final DateTime? exp = p['expiryDate'] as DateTime?;
        return {
          "productId": p["productId"],
          "receivedQty": p["receivedQty"],
          "bonusQty": p["bonusQty"],
          "invoicePrice": (p["invoicePrice"]),
          "sellingPrice": (p["sellingPrice"]),
          "minStockLevel": (p["minStockLevel"]),
          "batchNo": (p["batchNo"]),
          "expiryDate": exp != null ? [exp.year, exp.month, exp.day] : null,
          "productType": p["productType"],
        };
      }).toList();
      final Map<String, dynamic> body = {
        "purchaseOrderId": _purchaseOrder.value?.id,
        "supplierId": _purchaseOrder.value?.supplierId,
        "currency": _purchaseOrder.value!.currency,
        //"total": calculateTotalAmount(),
        "invoiceNumber": _invoiceNumberController.text,
        "items": items,
      };
      final langCode = LocaleController.to.locale.languageCode;
      final langParam = LanguageParam(key: "language", languageCode: langCode);
      final result = await addPurchaseInvoiceUseCase(
        params: langParam,
        body: body,
      );

      return result.fold(
        (failure) {
          if (failure.statusCode == 409) {
            Get.snackbar('Error', failure.errMessage);
            print(failure.errMessage.toString());
          }
          if (failure.statusCode == 401) {
            Get.snackbar('Error'.tr, "login cancel".tr);
          } else {
            Get.snackbar(
              'Error',
              failure.errMessage,
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red.shade400,
              colorText: Colors.white,
            );
          }
        },
        (savedInvoice) {
          Get.snackbar(
            'Successful',
            "Invoice created successfully".tr,
            snackPosition: SnackPosition.TOP,
          );
          _hasUnsavedChanges.value = false;
          resetForm();
          // Future.delayed(const Duration(milliseconds: 500), () {
          //   Get.back();
          // });
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred. Please try again.'.tr;
      Get.snackbar(
        'Error'.tr,
        errorMessage.value,
      );
    } finally {
      _isSaving.value = false;
    }
  }

  void clearUnsavedChanges() {
    _hasUnsavedChanges.value = false;
  }

  void resetForm() {
    _invoiceNumberController.clear();
    _searchController.clear();

    _purchaseOrder.value = null;
    _products.clear();
    _isSaving.value = false;
    _searchQuery.value = '';
    _hasUnsavedChanges.value = false;

    _products.refresh();
  }
}
