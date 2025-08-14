import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/features/purchase_invoice/AddPurchaseInvoice/presentation/pages/widgets/invoice_products_table_widget.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/purchase_model .dart';

import '../controllers/add_purchase_invoice_controller.dart';
import '../widgets/invoice_header_widget.dart';
import '../widgets/purchase_order_info_widget.dart';
import '../widgets/invoice_summary_widget.dart';
import '../widgets/payment_success_dialog.dart';

class EnhancedCreateInvoiceScreen extends StatefulWidget {
  const EnhancedCreateInvoiceScreen({super.key});

  @override
  State<EnhancedCreateInvoiceScreen> createState() =>
      _EnhancedCreateInvoiceScreenState();
}

class _EnhancedCreateInvoiceScreenState
    extends State<EnhancedCreateInvoiceScreen> {
  late final AddPurchaseInvoiceController controller;
  late PurchaseOrderModel orderItem;

  @override
  void initState() {
    super.initState();
    controller = Get.find<AddPurchaseInvoiceController>();
    orderItem = Get.arguments as PurchaseOrderModel;
    _loadPurchaseOrderData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء فاتورة شراء'),
        // leading: IconButton(
        //   onPressed: _cancelInvoiceCreation,
        //   icon: CustomIconWidget(
        //     iconName: 'close',
        //     color: Theme.of(context).colorScheme.onSurface,
        //     size: 24,
        //   ),
        // ),
      ),
      body: Form(
        key: controller.formKey,
        child: Column(
          children: [
            // Header Section
            InvoiceHeaderWidget(
              invoiceNumberController: controller.invoiceNumberController,
              searchController: controller.searchController,
              onSearchChanged: controller.onSearchChanged,
              onBarcodeScanned: controller.onBarcodeScanned,
              onInvoiceNumberChanged: controller.markAsChanged,
            ),

            // Products Table (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                controller: controller.scrollController,
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.purchaseOrder != null) ...[
                      // Purchase Order Info
                      PurchaseOrderInfoWidget(
                        purchaseOrder: controller.purchaseOrder!,
                      ),

                      SizedBox(height: 3.h),
                    ],

                    // Products Table
                    Text(
                      'المنتجات من طلب الشراء',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    SizedBox(height: 2.h),

                    InvoiceProductsTableWidget(
                      products: controller.products,
                      searchQuery: controller.searchQuery,
                      onProductDataChanged: controller.onProductDataChanged,
                    ),

                    SizedBox(height: 3.h),

                    // Invoice Summary
                    InvoiceSummaryWidget(
                      totalReceivedItems: controller.getTotalReceivedItems(),
                      totalBonusItems: controller.getTotalBonusItems(),
                      totalAmount: controller.calculateTotalAmount(),
                      isSaving: controller.isSaving,
                      onProceedToPayment: _proceedToPayment,
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadPurchaseOrderData() {
    controller.setPurchaseOrder(orderItem);
  }

  Future<void> _proceedToPayment() async {
    if (!controller.validateForm()) {
      Get.snackbar(
        'خطأ',
        'يجب إدخال الكمية المستلمة لمنتج واحد على الأقل',
        backgroundColor: Get.theme!.colorScheme.error,
        colorText: Get.theme!.colorScheme.onError,
      );
      return;
    }

    final success = await controller.saveInvoice();

    if (success) {
      _showPaymentSuccessDialog();
    } else {
      Get.snackbar(
        'خطأ',
        'فشل في حفظ الفاتورة. الرجاء المحاولة مرة أخرى',
        backgroundColor: Get.theme!.colorScheme.error,
        colorText: Get.theme!.colorScheme.onError,
      );
    }
  }

  void _showPaymentSuccessDialog() {
    Get.dialog(
      PaymentSuccessDialog(
        invoiceNumber: controller.invoiceNumberController.text,
        supplier: controller.purchaseOrder?.supplierName ?? '',
        totalAmount: controller.calculateTotalAmount(),
        products: controller.products
            .where((p) => (p['receivedQuantity'] as int) > 0)
            .toList(),
        onGoHome: () {
          Get.back();
          Get.offAllNamed(AppPages.purchaseOrderSelection);
        },
    
      ),
      barrierDismissible: false,
    );
  }

  // void _cancelInvoiceCreation() {
  //   if (controller.hasUnsavedChanges) {
  //     Get.dialog(
  //       CancelInvoiceDialog(
  //         onContinueEditing: () => Get.back(),
  //         onCancel: () {
  //           Get.back();
  //           Get.back();
  //         },
  //       ),
  //     );
  //   } else {
  //     Get.back();
  //   }
  // }
}
