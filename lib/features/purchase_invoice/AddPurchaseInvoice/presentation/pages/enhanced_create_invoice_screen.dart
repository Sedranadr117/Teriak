import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/bottom_sheet_management/barcode_bottom_sheet.dart';
import 'package:teriak/features/money_box/presentation/controller/get_money_box_controlller.dart';
import 'package:teriak/features/money_box/presentation/controller/get_money_box_transaction_controlller.dart';
import 'package:teriak/features/products/all_products/presentation/controller/get_allProduct_controller.dart';
import 'package:teriak/features/purchase_invoice/AddPurchaseInvoice/presentation/pages/widgets/invoice_products_table_widget.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/presentation/controller/all_purchase_invoice_controller.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/purchase_model .dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/presentation/controller/all_purchase_order_controller.dart';
import 'package:teriak/features/stock_management/presentation/controller/stock_controller.dart';
import '../controllers/add_purchase_invoice_controller.dart';
import 'widgets/invoice_header_widget.dart';
import 'widgets/invoice_summary_widget.dart';

class EnhancedCreateInvoiceScreen extends StatefulWidget {
  const EnhancedCreateInvoiceScreen({super.key});

  @override
  State<EnhancedCreateInvoiceScreen> createState() =>
      _EnhancedCreateInvoiceScreenState();
}

class _EnhancedCreateInvoiceScreenState
    extends State<EnhancedCreateInvoiceScreen> {
  late PurchaseOrderModel orderItem;
  late final AddPurchaseInvoiceController controller;
  late final AllPurchaseInvoiceController allController;
  late final GetAllPurchaseOrderController orderController;
  late final GetAllProductController allProductController;
  late final StockController stockController;
  late final GetMoneyBoxController moneyBoxController;
  late final GetMoneyBoxTransactionController moneyBoxTransactionController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AddPurchaseInvoiceController>();
    allController = Get.find<AllPurchaseInvoiceController>();
    orderController = Get.find<GetAllPurchaseOrderController>();
    allProductController = Get.put(GetAllProductController());
    stockController = Get.put(StockController());
    moneyBoxController = Get.find<GetMoneyBoxController>();
    moneyBoxTransactionController = Get.find<GetMoneyBoxTransactionController>();
    orderItem = Get.arguments as PurchaseOrderModel;
    _loadPurchaseOrderData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(EnhancedCreateInvoiceScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (mounted) {
      _refreshUI();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _refreshUI() {
    if (mounted) {
      setState(() {});
    }
  }

  void _loadPurchaseOrderData() {
    controller.setPurchaseOrder(orderItem);
    _refreshUI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Purchase Invoice'.tr),
        // leading: IconButton(
        //   onPressed: _cancelInvoiceCreation,
        //   icon: CustomIconWidget(
        //     iconName: 'close',
        //     color: Theme.of(context).colorScheme.onSurface,
        //     size: 24,
        //   ),
        // ),
      ),
      body: Obx(
        () => Form(
          key: controller.formKey,
          child: Column(
            children: [
              // Header Section
              if (controller.purchaseOrder != null)
                InvoiceHeaderWidget(
                  key: ValueKey('${controller.searchQuery}'),
                  supplierName: controller.purchaseOrder!.supplierName,
                  currency: controller.purchaseOrder!.currency,
                  date: controller.purchaseOrder!.formattedCreationDateTime,
                  searchController: controller.searchController,
                  onSearchChanged: (query) {
                    controller.onSearchChanged(query);
                    _refreshUI();
                  },
                  onBarcodeScanned: () async {
                    await showBarcodeScannerBottomSheet(
                      onScanned: (code) {
                        controller.onBarcodeScanned(code);
                        _refreshUI();
                      },
                    );
                  },
                ),

              // Products Table (Scrollable)
              Expanded(
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: controller.invoiceNumberController,
                        decoration: InputDecoration(
                          labelText: 'Invoice Number'.tr,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'receipt_long',
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),

                      // Products Table
                      if (controller.purchaseOrder != null)
                      Text(
                        'Products from Purchase Order'.tr,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      SizedBox(height: 2.h),
                      if (controller.purchaseOrder != null)
                        InvoiceProductsTableWidget(
                          key: ValueKey(
                              '${controller.products.length}_${controller.searchQuery}'),
                          products: controller.products,
                          searchQuery: controller.searchQuery,
                          onProductDataChanged: (index, data) {
                            controller.onProductDataChanged(index, data);
                            _refreshUI();
                          },
                          currency: controller.purchaseOrder!.currency,
                        ),

                      SizedBox(height: 3.h),

                      // Invoice Summary
                      if (controller.purchaseOrder != null)
                      Obx(
                        () => InvoiceSummaryWidget(
                          key: ValueKey(
                              '${controller.getTotalReceivedItems()}_${controller.getTotalBonusItems()}_${controller.calculateTotalAmount()}'),
                          totalReceivedItems:
                              controller.getTotalReceivedItems(),
                          totalBonusItems: controller.getTotalBonusItems(),
                          totalAmount: controller.calculateTotalAmount(),
                          isSaving: controller.isSaving,
                            currency: controller.purchaseOrder!.currency,
                          onProceedToPayment: () async {
                            await controller.saveInvoice();
                            // _refreshUI();
                            allController.refreshPurchaseInvoices();
                            orderController.refreshPurchaseOrders();
                            orderController.getAllPendingPurchaseOrders();
                            allProductController.refreshProducts();
                            stockController.refreshStock();
                            moneyBoxController.refreshData();
                            moneyBoxTransactionController.refreshData();
                          },
                        ),
                      ),

                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
