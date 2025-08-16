import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/features/purchase_order/edit_purchase_order/presentation/controller/edit_purchase_order_controller.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/presentation/pages/widgets/supplier_selection_card.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/presentation/pages/widgets/currency_selection_card.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/presentation/pages/widgets/product_selection_card.dart';
import 'package:teriak/features/purchase_order/edit_purchase_order/presentation/pages/widgets/edit_order_items_list.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/presentation/pages/widgets/order_summary_card.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/presentation/pages/widgets/create_order_button.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/purchase_entity .dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/presentation/controller/all_purchase_order_controller.dart';
import 'package:teriak/features/purchase_order/purchase_order_deatails/presentation/controller/purchase_order_details_controller.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/controller/all_supplier_controller.dart';
import 'package:teriak/features/products/all_products/presentation/controller/get_allProduct_controller.dart';

class EditPurchaseOrderPage extends StatefulWidget {
  final PurchaseOrderEntity order;
  final int? supplierId;

  const EditPurchaseOrderPage({
    super.key,
    required this.order,
    this.supplierId,
  });

  @override
  State<EditPurchaseOrderPage> createState() => _EditPurchaseOrderPageState();
}

class _EditPurchaseOrderPageState extends State<EditPurchaseOrderPage> {
  late final EditPurchaseOrderController controller;
  final GetAllSupplierController supplierController = Get.find();
  final GetAllProductController productController = Get.find();
  final GetAllPurchaseOrderController orderController = Get.find();
  final PurchaseOrderDetailsController detailsController = Get.find();

  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(EditPurchaseOrderController());
    _loadData();
  }

  void _loadData() {
    print('EditPurchaseOrderPage: Starting to load data');
    print(
        'EditPurchaseOrderPage: Suppliers count: ${supplierController.suppliers.length}');
    print(
        'EditPurchaseOrderPage: Products count: ${productController.products.length}');

    // Load suppliers and products when page initializes
    supplierController.getSuppliers();
    productController.getProducts();

    // Initialize controller with order data after data is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print(
          'EditPurchaseOrderPage: Post frame callback - Suppliers: ${supplierController.suppliers.length}, Products: ${productController.products.length}');

      if (supplierController.suppliers.isNotEmpty &&
          productController.products.isNotEmpty) {
        print('EditPurchaseOrderPage: Data loaded, initializing controller');
        controller.loadOrderData(widget.order, supplierId: widget.supplierId);
        setState(() {
          _isDataLoaded = true;
        });
        print('EditPurchaseOrderPage: Controller initialized, data loaded');
      } else {
        print('EditPurchaseOrderPage: Data not loaded yet, retrying...');
        // If data is not loaded yet, check again after a short delay
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _loadData();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Edit Purchase Order'.tr),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        // actions: [
        //   Container(
        //     margin: EdgeInsets.only(right: 3.w),
        //     padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        //     decoration: BoxDecoration(
        //       color: Theme.of(context).colorScheme.primary,
        //       borderRadius: BorderRadius.circular(12),
        //     ),
        //     child: Text(
        //       'Modified'.tr,
        //       style: TextStyle(
        //         color: Theme.of(context).colorScheme.onPrimary,
        //         fontSize: 12.sp,
        //         fontWeight: FontWeight.w600,
        //       ),
        //     ),
        //   )
        // ],
      ),
      body: _isDataLoaded
          ? Obx(() => _buildBody())
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Supplier Selection
          Obx(() => SupplierSelectionCard(
                suppliers: controller.suppliers.cast(),
                onSupplierSelected: controller.selectSupplier,
                selectedSupplier: controller.selectedSupplier.value,
                errorText: controller.supplierError.value,
              )),

          SizedBox(height: 1.5.h),

          // Currency Selection
          CurrencySelectionCard(
            selectedCurrency: controller.selectedCurrency.value,
            onCurrencyChanged: controller.selectCurrency,
            availableCurrencies: controller.availableCurrencies,
          ),

          SizedBox(height: 1.5.h),

          // Product Selection
          Obx(() => ProductSelectionCard(
                products: controller.products.cast(),
                onProductSelected: controller.selectProduct,
                onBarcodeScanned: controller.selectProductByBarcode,
                selectedProduct: controller.selectedProduct.value,
                barcodeController: controller.barcodeController,
                quantityController: controller.quantityController,
                priceController: controller.priceController,
                currentQuantity: controller.currentQuantity.value,
                currentPrice: controller.currentPrice.value,
                onQuantityChanged: controller.updateQuantity,
                onPriceChanged: controller.updatePrice,
                onAddProduct: controller.addProductToOrder,
                productError: controller.productError.value,
                quantityError: controller.quantityError.value,
                priceError: controller.priceError.value,
              )),

          SizedBox(height: 3.h),

          // Order Items List
          EditOrderItemsList(
            items: controller.orderItems,
            currency: controller.selectedCurrency.value,
            onUpdateItem: (index, {price, quantity}) {
              // Convert back to EditPurchaseOrderItem
              final editItem = controller.orderItems[index];
              if (quantity != null) {
                controller.updateOrderItemQuantity(index, quantity);
              }
              if (price != null) {
                controller.updateOrderItemPrice(index, price);
              }
            },
            onRemoveItem: controller.removeOrderItem,
          ),

          SizedBox(height: 1.5.h),

          // Order Summary
          OrderSummaryCard(
            total: controller.orderTotal,
            currency: controller.selectedCurrency.value,
            itemCount: controller.orderItems.length,
          ),

          SizedBox(height: 1.5.h),

          // Update Order Button
          CreateOrderButton(
            onPressed: () {
              controller.updatePurchaseOrder();
              orderController.refreshPurchaseOrders();
              detailsController.refreshPurchaseOrderDetails();
            },
            isLoading: controller.isLoading.value,
            isEnabled: controller.canUpdateOrder,
            buttonText: 'Update Order'.tr,
          ),

          SizedBox(height: 1.5.h),
        ],
      ),
    );
  }

  // Helper method to convert EditPurchaseOrderItem to the format expected by OrderItemsList
  dynamic _convertToOrderItem(EditPurchaseOrderItem item) {
    // Create a simple map structure that matches what OrderItemsList expects
    return {
      'product': item.product,
      'quantity': item.quantity,
      'price': item.price,
      'total': item.total,
    };
  }
}
