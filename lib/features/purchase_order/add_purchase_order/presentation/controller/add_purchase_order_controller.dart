import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/products/all_products/domain/entities/product_entity.dart';
import 'package:teriak/features/products/all_products/presentation/controller/get_allProduct_controller.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/data/datasources/add_purchase_remote_data_source.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/data/repositories/add_purchase_repository_impl.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/domain/usecases/post_add_purchase.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import 'package:teriak/features/products/all_products/data/models/product_model.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/controller/all_supplier_controller.dart';

class PurchaseOrderItem {
  final ProductEntity product;
  final int quantity;
  final double price;
  double get total => quantity * price;

  PurchaseOrderItem({
    required this.product,
    required this.quantity,
    required this.price,
  });

  PurchaseOrderItem copyWith({
    ProductEntity? product,
    int? quantity,
    double? price,
  }) {
    return PurchaseOrderItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}

class AddPurchaseOrderController extends GetxController {
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  var selectedSupplier = Rxn<SupplierModel>();
  var selectedCurrency = 'SYP'.obs;
  var selectedProduct = Rxn<ProductEntity>();
  var orderItems = <PurchaseOrderItem>[].obs;
  var currentQuantity = 1.obs;
  var currentPrice = 0.0.obs;
  var isLoading = false.obs;
  var isPharmacist = true.obs; // This should be determined based on user role

  var supplierError = RxnString();
  var productError = RxnString();
  var quantityError = RxnString();
  var priceError = RxnString();

  late final NetworkInfoImpl networkInfo;
  late final AddPurchaseOrder addPurchaseOrderUseCase;

  var products = <ProductModel>[].obs;
  final productController = Get.find<GetAllProductController>();
  final supplierController = Get.find<GetAllSupplierController>();

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();

    quantityController.addListener(_updateQuantity);
    priceController.addListener(_updatePrice);
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    networkInfo = NetworkInfoImpl(InternetConnection());

    final remoteDataSource =
        AddPurchaseOrderRemoteDataSource(api: httpConsumer);

    final repository = AddPurchaseOrderRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    addPurchaseOrderUseCase = AddPurchaseOrder(repository: repository);
  }

  double get orderTotal =>
      orderItems.fold(0.0, (sum, item) => sum + item.total);
  bool get hasItems => orderItems.isNotEmpty;
  bool get canCreateOrder => selectedSupplier.value != null && hasItems;

  void selectCurrency(String currency) {
    selectedCurrency.value = currency;
  }

  List<String> get availableCurrencies => ['SYP', 'USD'];

  void selectSupplier(SupplierModel supplier) {
    // Find the exact supplier from the suppliers list to ensure reference equality
    final existing = supplierController.suppliers.firstWhere(
      (s) => s.id == supplier.id,
      orElse: () => supplier,
    );

    // Ensure we're using the exact instance from the suppliers list
    selectedSupplier.value = existing;
    supplierError.value = null;
  }

  void clearSupplierError() {
    supplierError.value = null;
  }

  void selectProduct(ProductEntity product) {
    // Find the exact product from the products list to ensure reference equality
    final existing = productController.products.firstWhere(
      (p) => p.id == product.id && p.productType == product.productType,
      orElse: () => product,
    );

    // Ensure we're using the exact instance from the products list
    selectedProduct.value = existing;
    productError.value = null;

    _handleProductPriceLogic(existing);
  }

  void _handleProductPriceLogic(ProductEntity product) {
    final productType = product.productType;
    final isMasterProduct = productType == "Master" || productType == "مركزي";
    if (isMasterProduct) {
      double price =
          (product.refPurchasePrice > 0) ? product.refPurchasePrice : 2.0;
      currentPrice.value = price;
      priceController.text = price.toStringAsFixed(2);
    } else {
      currentPrice.value = product.refPurchasePrice;
      priceController.text = product.refPurchasePrice.toStringAsFixed(2);
    }
  }

  void selectProductByBarcode(String barcode) {
    final product = productController.products.firstWhereOrNull(
      (p) => p.barcodes?.contains(barcode) == true,
    );

    if (product != null) {
      selectProduct(product);
      barcodeController.text = barcode;
    } else {
      Get.snackbar(
        'Error'.tr,
        'not found'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void clearProductError() {
    productError.value = null;
  }

  void _updateQuantity() {
    final text = quantityController.text.trim();
    if (text.isNotEmpty) {
      final quantity = int.tryParse(text);
      if (quantity != null && quantity > 0) {
        currentQuantity.value = quantity;
        quantityError.value = null;
      }
    }
  }

  void _updatePrice() {
    final text = priceController.text.trim();
    if (text.isNotEmpty) {
      final price = double.tryParse(text);
      if (price != null && price > 0) {
        currentPrice.value = price;
        priceError.value = null;
      }
    }
  }

  void updateQuantity(int quantity) {
    if (quantity > 0) {
      currentQuantity.value = quantity;
      quantityController.text = quantity.toString();
      quantityError.value = null;
    }
  }

  void updatePrice(double price) {
    if (price > 0) {
      currentPrice.value = price;
      priceController.text = price.toString();
      priceError.value = null;
    }
  }

  void addProductToOrder() {
    if (!_validateCurrentProduct()) return;

    final product = selectedProduct.value!;
    final quantity = currentQuantity.value;
    final price = currentPrice.value;

    final existingIndex = orderItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      final existingItem = orderItems[existingIndex];
      orderItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
    } else {
      orderItems.add(PurchaseOrderItem(
        product: product,
        quantity: quantity,
        price: price,
      ));
    }

    _clearCurrentProductData();
  }

  void updateOrderItem(int index, {int? quantity, double? price}) {
    if (index >= 0 && index < orderItems.length) {
      final item = orderItems[index];
      orderItems[index] = item.copyWith(
        quantity: quantity,
        price: price,
      );
    }
  }

  void removeOrderItem(int index) {
    if (index >= 0 && index < orderItems.length) {
      orderItems.removeAt(index);
    }
  }

  void clearOrderItems() {
    orderItems.clear();
  }

  bool _validateCurrentProduct() {
    bool isValid = true;

    if (selectedProduct.value == null) {
      productError.value = 'Please select a product'.tr;
      isValid = false;
    }

    if (currentQuantity.value <= 0) {
      quantityError.value = 'Please enter quantity'.tr;
      isValid = false;
    }

    if (currentPrice.value <= 0) {
      priceError.value = 'Please enter price'.tr;
      isValid = false;
    }

    return isValid;
  }

  bool _validateOrder() {
    bool isValid = true;

    if (selectedSupplier.value == null) {
      supplierError.value = 'Please select a supplier'.tr;
      isValid = false;
    }

    if (orderItems.isEmpty) {
      Get.snackbar(
        'Error'.tr,
        'Please add at least one product'.tr,
        snackPosition: SnackPosition.TOP,
      );
      isValid = false;
    }

    return isValid;
  }

  void _clearCurrentProductData() {
    selectedProduct.value = null;
    currentQuantity.value = 1;
    currentPrice.value = 0.0;
    barcodeController.clear();
    quantityController.clear();
    priceController.clear();
  }

  void clearValidationErrors() {
    supplierError.value = null;
    productError.value = null;
    quantityError.value = null;
    priceError.value = null;
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

  Map<String, dynamic> buildRequestBody() {
    final items = orderItems
        .map((item) => {
              "productId": item.product.id,
              "quantity": item.quantity,
              "price": item.price,
              "productType":
                  mapProductType(item.product.productType),
            })
        .toList();

    return {
      "supplierId": selectedSupplier.value!.id,
      "currency": selectedCurrency.value,
      "items": items,
    };
  }

  Future<void> createPurchaseOrder() async {
    if (!_validateOrder()) return;

    isLoading.value = true;
    clearValidationErrors();

    try {
      final languageCode = LocaleController.to.locale.languageCode;
      final params = LanguageParam(languageCode: languageCode, key: 'language');
      final body = buildRequestBody();

      final result = await addPurchaseOrderUseCase.call(
        params: params,
        body: body,
      );
      print("Currency sent: ${selectedCurrency.value}");
      print("Request body: $body");

      result.fold(
        (failure) {
          Get.snackbar(
            'Error'.tr,
            failure.errMessage,
            snackPosition: SnackPosition.TOP,
          );
        },
        (purchaseOrder) {
          Get.snackbar(
            'Success'.tr,
            'Purchase order created successfully'.tr,
            snackPosition: SnackPosition.TOP,
          );

          _resetForm();
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'An unexpected error occurred. Please try again.'.tr,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _resetForm() {
    selectedSupplier.value = null;
    selectedCurrency.value = 'SYP';
    orderItems.clear();
    _clearCurrentProductData();
    clearValidationErrors();
  }

  @override
  void onClose() {
    barcodeController.dispose();
    quantityController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
