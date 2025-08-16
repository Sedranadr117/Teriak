import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/purchase_model%20.dart';
import '../../controller/all_purchase_invoice_controller.dart';
import '../../../../../purchase_order/all_purchase_orders/presentation/controller/all_purchase_order_controller.dart';
import '../../../../AddPurchaseInvoice/presentation/pages/enhanced_create_invoice_screen.dart';

class PurchaseOrderSelectionWidget extends StatelessWidget {
  const PurchaseOrderSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final invoiceController = Get.find<AllPurchaseInvoiceController>();
    final orderController = Get.find<GetAllPurchaseOrderController>();
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.shopping_cart,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Purchase Order'.tr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Choose a pending purchase order to create invoice'.tr,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Dropdown Selection
          Obx(() {
            if (orderController.isLoadingPendingOrders.value) {
              return Container(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    SizedBox(
                      width: 4.w,
                      height: 4.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Loading purchase orders'.tr,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (orderController.errorMessagePendingOrders.value.isNotEmpty) {
              return Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: theme.colorScheme.error,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        orderController.errorMessagePendingOrders.value,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: orderController.getAllPendingPurchaseOrders,
                      child: Text('Retry'.tr),
                    ),
                  ],
                ),
              );
            }

            // Filter PENDING orders only
            final pendingOrders = orderController.pendingPurchaseOrders
                .where((order) => order.status == 'PENDING')
                .toList();

            if (pendingOrders.isEmpty) {
              return Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'No pending purchase orders available'.tr,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pending Orders'.tr,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: DropdownButtonFormField<int>(
                    value: invoiceController.selectedOrderId.value,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Select Purchase Order'.tr,
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    items: pendingOrders.map((order) {
                      print(pendingOrders.length);
                      return DropdownMenuItem<int>(
                        value: order.id,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 60.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order.supplierName,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                '${order.total} ${order.currency}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        invoiceController.selectPurchaseOrder(value);
                      }
                    },
                    dropdownColor: theme.colorScheme.surface,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    isExpanded: true,
                  ),
                ),

                // Create Invoice Button
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  child: Obx(() {
                    final isOrderSelected =
                        invoiceController.selectedOrderId.value != null;
                    return ElevatedButton.icon(
                     
                      onPressed: isOrderSelected
                          ? () {
                              final selectedOrder = pendingOrders.firstWhere(
                                (order) =>
                                    order.id ==
                                    invoiceController.selectedOrderId.value,
                              );

                              Get.toNamed(
                                AppPages.enhancedCreateInvoice,
                                arguments: selectedOrder as PurchaseOrderModel,
                              );
                            }
                          : null,
                      icon: Icon(
                        Icons.add_shopping_cart,
                        size: 20,
                      ),
                      label: Text(
                        'Create Invoice'.tr,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.onPrimaryLight,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
