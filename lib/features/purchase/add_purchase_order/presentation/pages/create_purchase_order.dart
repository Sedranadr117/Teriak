import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/features/purchase/add_purchase_order/presentation/controller/add_purchase_order_controller.dart';
import 'package:teriak/features/purchase/all_purchase_orders/presentation/controller/all_purchase_order_controller.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/controller/all_supplier_controller.dart';
import 'package:teriak/features/master_product/presentation/controller/get_allProduct_controller.dart';
import 'widgets/supplier_selection_card.dart';
import 'widgets/currency_selection_card.dart';
import 'widgets/product_selection_card.dart';
import 'widgets/order_items_list.dart';
import 'widgets/order_summary_card.dart';
import 'widgets/create_order_button.dart';

class CreatePurchaseOrderPage extends StatefulWidget {
  const CreatePurchaseOrderPage({super.key});

  @override
  State<CreatePurchaseOrderPage> createState() =>
      _CreatePurchaseOrderPageState();
}

class _CreatePurchaseOrderPageState extends State<CreatePurchaseOrderPage> {
  final AddPurchaseOrderController controller = Get.find();
  final GetAllSupplierController supplierController = Get.find();
  final GetAllProductController productController = Get.find();
  final GetAllPurchaseOrderController orderController = Get.find();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Load suppliers and products when page initializes
    supplierController.getSuppliers();
    productController.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Create Purchase Order'.tr),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (supplierController.isLoading.value ||
            productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return _buildBody();
      }),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Supplier Selection
          SupplierSelectionCard(
            suppliers: supplierController.suppliers.cast(),
            onSupplierSelected: controller.selectSupplier,
            selectedSupplier: controller.selectedSupplier.value,
            errorText: controller.supplierError.value,
          ),

          SizedBox(height: 1.5.h),

          // Currency Selection
          CurrencySelectionCard(
            selectedCurrency: controller.selectedCurrency.value,
            onCurrencyChanged: controller.selectCurrency,
            availableCurrencies: controller.availableCurrencies,
          ),

          SizedBox(height: 1.5.h),

          // Product Selection
          ProductSelectionCard(
            products: productController.products.cast(),
            onProductSelected: controller.selectProduct,
            onBarcodeScanned: controller.selectProductByBarcode,
            selectedProduct: controller.selectedProduct.value,
            barcodeController: controller.barcodeController,
            quantityController: controller.quantityController,
            priceController: controller.priceController,
            currentQuantity: controller.currentQuantity.value,
            currentPrice: controller.currentPrice.value,
            isPharmacist: controller.isPharmacist.value,
            onQuantityChanged: controller.updateQuantity,
            onPriceChanged: controller.updatePrice,
            onAddProduct: controller.addProductToOrder,
            productError: controller.productError.value,
            quantityError: controller.quantityError.value,
            priceError: controller.priceError.value,
          ),

          SizedBox(height: 3.h),

          // Order Items List
          OrderItemsList(
            items: controller.orderItems,
            currency: controller.selectedCurrency.value,
            onUpdateItem: controller.updateOrderItem,
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

          // Create Order Button
          CreateOrderButton(
            onPressed: () {
              controller.createPurchaseOrder();
              orderController.refreshPurchaseOrders();
            },
            isLoading: controller.isLoading.value,
            isEnabled: controller.canCreateOrder,
            buttonText: 'Create Order'.tr,
          ),

          SizedBox(height: 1.5.h),
        ],
      ),
    );
  }
}
