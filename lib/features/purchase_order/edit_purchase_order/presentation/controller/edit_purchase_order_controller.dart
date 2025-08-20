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
import 'package:teriak/features/purchase_order/edit_purchase_order/data/datasources/edit_purchase_remote_data_source.dart';
import 'package:teriak/features/purchase_order/edit_purchase_order/data/repositories/edit_purchase_repository_impl.dart';
import 'package:teriak/features/purchase_order/edit_purchase_order/domain/usecases/put_edit_purchase.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import 'package:teriak/features/products/all_products/data/models/product_model.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/controller/all_supplier_controller.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/purchase_entity .dart';

class EditPurchaseOrderItem {
  final ProductEntity product;
  final int quantity;
  final double price;
  final String productType;
  double get total => quantity * price;

  EditPurchaseOrderItem({
    required this.product,
    required this.quantity,
    required this.price,
    required this.productType,
  });

  EditPurchaseOrderItem copyWith({
    ProductEntity? product,
    int? quantity,
    double? price,
    String? productType,
  }) {
    return EditPurchaseOrderItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      productType: productType ?? this.productType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': product.id,
      'quantity': quantity,
      'price': price,
      'productType': productType,
    };
  }
}

class EditPurchaseOrderController extends GetxController {
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  var selectedSupplier = Rxn<SupplierModel>();
  var selectedCurrency = 'SYP'.obs;
  var selectedProduct = Rxn<ProductEntity>();
  var orderItems = <EditPurchaseOrderItem>[].obs;
  var currentQuantity = 1.obs;
  var currentPrice = 0.0.obs;
  var isLoading = false.obs;
  var isPharmacist = true.obs;
  var isInitializing = false.obs; // Start with false

  // Available currencies
  final List<String> availableCurrencies = ['SYP', 'USD'];

  var supplierError = RxnString();
  var productError = RxnString();
  var quantityError = RxnString();
  var priceError = RxnString();

  late final NetworkInfoImpl networkInfo;
  late final EditPurchaseOrders editPurchaseOrderUseCase;

  var suppliers = <SupplierModel>[].obs;
  var products = <ProductModel>[].obs;
  final productController = Get.find<GetAllProductController>();
  final supplierController = Get.find<GetAllSupplierController>();

  // Original order data for comparison
  PurchaseOrderEntity? originalOrder;
  int? orderId;
  int? originalSupplierId; // Store supplier ID separately
  String? originalSupplierName; // Store supplier name for comparison

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    _setupControllers();
  }

  void _initializeDependencies() {
    print('EditPurchaseOrderController: Initializing dependencies');
    final cacheHelper = CacheHelper();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    networkInfo = NetworkInfoImpl(InternetConnection());

    final remoteDataSource =
        EditPurchaseOrdersRemoteDataSource(api: httpConsumer);

    final repository = EditPurchaseOrdersRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    editPurchaseOrderUseCase = EditPurchaseOrders(repository: repository);
  }

  void _setupControllers() {
    quantityController.addListener(_updateQuantity);
    priceController.addListener(_updatePrice);

    ever(supplierController.suppliers, (suppliers) {
      if (suppliers.isNotEmpty) {
        this.suppliers.value = suppliers.cast<SupplierModel>();

        if (originalOrder != null && !isInitializing.value) {
          loadOrderData(originalOrder!, supplierId: originalSupplierId);
        }
      }
    });

    ever(productController.products, (products) {
      if (products.isNotEmpty) {
        this.products.value = products.cast<ProductModel>();
        if (originalOrder != null && !isInitializing.value) {
          loadOrderData(originalOrder!, supplierId: originalSupplierId);
        }
      }
    });
  }

  void _updateQuantity() {
    final quantity = int.tryParse(quantityController.text);
    if (quantity != null && quantity > 0) {
      currentQuantity.value = quantity;
    }
  }

  void _updatePrice() {
    final price = double.tryParse(priceController.text);
    if (price != null && price >= 0) {
      currentPrice.value = price;
    }
  }

  void loadOrderData(PurchaseOrderEntity order, {int? supplierId}) async {
    isInitializing.value = true;

    originalOrder = order;
    orderId = order.id;
    originalSupplierId = supplierId;
    originalSupplierName = order.supplierName;

    suppliers.value = supplierController.suppliers.cast<SupplierModel>();
    products.value = productController.products.cast<ProductModel>();

    if (supplierId != null) {
      final supplier = suppliers.firstWhereOrNull((s) => s.id == supplierId);
      if (supplier != null) {
        selectSupplier(supplier);
      } else {
        print(
            'EditPurchaseOrderController: Supplier with ID $supplierId not found');
      }
    }

    // Set currency
    selectedCurrency.value = order.currency ?? 'SYP';

    if (order.items != null) {
      orderItems.value = order.items!
          .map((item) {
            final product =
                products.firstWhereOrNull((p) => p.id == item.productId);
            if (product != null) {
              return EditPurchaseOrderItem(
                product: product,
                quantity: item.quantity,
                price: item.price,
                productType: product.productType.toUpperCase(),
              );
            }
            return null;
          })
          .whereType<EditPurchaseOrderItem>()
          .toList();
    }

    isInitializing.value = false;
  }

  void initializeWithOrder(PurchaseOrderEntity order, {int? supplierId}) {
    loadOrderData(order, supplierId: supplierId);
  }

  void selectSupplier(SupplierModel supplier) {
    selectedSupplier.value = supplier;
    supplierError.value = null;
  }

  void selectCurrency(String currency) {
    selectedCurrency.value = currency;
  }

  void selectProduct(ProductEntity product) {
    selectedProduct.value = product;
    currentPrice.value = 0.0;
    priceController.text = '0.0';
    productError.value = null;
    _handleProductPriceLogic(product);
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
      productError.value = 'Product not found'.tr;
    }
  }

  void updateQuantity(int quantity) {
    currentQuantity.value = quantity;
    quantityController.text = quantity.toString();
    quantityError.value = null;
  }

  void updatePrice(double price) {
    if (price > 0) {
      currentPrice.value = price;
      priceController.text = price.toString();
      priceError.value = null;
    }
  }

  void addProductToOrder() {
    if (selectedProduct.value == null) {
      productError.value = 'Please select a product'.tr;
      return;
    }

    if (currentQuantity.value <= 0) {
      quantityError.value = 'Quantity must be greater than 0'.tr;
      return;
    }

    if (currentPrice.value < 0) {
      priceError.value = 'Price cannot be negative'.tr;
      return;
    }

    final newItem = EditPurchaseOrderItem(
      product: selectedProduct.value!,
      quantity: currentQuantity.value,
      price: currentPrice.value,
      productType: selectedProduct.value!.productType.toUpperCase(),
    );

    orderItems.add(newItem);
    _resetProductSelection();
  }

  void _resetProductSelection() {
    selectedProduct.value = null;
    currentQuantity.value = 1;
    currentPrice.value = 0.0;
    quantityController.clear();
    priceController.clear();
    barcodeController.clear();
  }

  void updateOrderItem(int index, EditPurchaseOrderItem updatedItem) {
    if (index >= 0 && index < orderItems.length) {
      orderItems[index] = updatedItem;
    }
  }

  void removeOrderItem(int index) {
    if (index >= 0 && index < orderItems.length) {
      final removedItem = orderItems[index];
      orderItems.removeAt(index);
    }
  }

  void updateOrderItemQuantity(int index, int newQuantity) {
    if (index >= 0 && index < orderItems.length) {
      final item = orderItems[index];
      orderItems[index] = item.copyWith(quantity: newQuantity);
    }
  }

  void updateOrderItemPrice(int index, double newPrice) {
    if (index >= 0 && index < orderItems.length) {
      final item = orderItems[index];
      orderItems[index] = item.copyWith(price: newPrice);
    }
  }

  double get orderTotal {
    final total = orderItems.fold(0.0, (sum, item) => sum + item.total);
    return total;
  }

  bool get canUpdateOrder {
    final canUpdate = selectedSupplier.value != null &&
        orderItems.isNotEmpty &&
        !isLoading.value;
    return canUpdate;
  }

  bool get hasChanges {
    if (originalOrder == null) return false;

    if (selectedSupplier.value?.name != originalSupplierName) {
      return true;
    }

    if (selectedCurrency.value != (originalOrder!.currency ?? 'SYP')) {
      return true;
    }

    if (orderItems.length != (originalOrder!.items?.length ?? 0)) {
      return true;
    }

    for (int i = 0; i < orderItems.length; i++) {
      final currentItem = orderItems[i];
      final originalItem = originalOrder!.items?[i];

      if (originalItem == null) return true;
      if (currentItem.product.id != originalItem.productId ||
          currentItem.quantity != originalItem.quantity ||
          currentItem.price != originalItem.price) {
        return true;
      }
    }

    return false;
  }

  Future<void> updatePurchaseOrder() async {
    if (!canUpdateOrder) return;

    isLoading.value = true;
    final languageCode = LocaleController.to.locale.languageCode;

    try {
      final params = EditPurchaseOrdersParams(
        id: orderId!,
        languageCode: languageCode,
      );

      final body = {
        'supplierId': selectedSupplier.value!.id,
        'currency': selectedCurrency.value,
        'items': orderItems.map((item) => item.toJson()).toList(),
      };

      final result = await editPurchaseOrderUseCase(params: params, body: body);

      result.fold(
        (failure) {
          Get.snackbar(
            'Error'.tr,
            'Failed to update purchase order'.tr,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        (updatedOrder) {
          Get.snackbar(
            'Success'.tr,
            'Purchase order updated successfully'.tr,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'An unexpected error occurred'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    barcodeController.dispose();
    quantityController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
