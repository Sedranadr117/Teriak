import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart' show AppPages;
import 'package:teriak/config/themes/app_icon.dart';
import '../../controller/all_purchase_invoice_controller.dart';
import 'invoice_card_widget.dart';

class InvoicesListWidget extends StatelessWidget {
  final ScrollController scrollController;

  const InvoicesListWidget({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AllPurchaseInvoiceController>();
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: theme.colorScheme.secondary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'All Invoices'.tr,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.secondary,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  Get.toNamed( AppPages.searchPurchaseInvoice,);
                },
                icon: CustomIconWidget(
                  iconName: 'search',
                  color: theme.colorScheme.onSurfaceVariant,
                  size:7.w,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Invoices List
          Expanded(
            child: Obx(() {
              if (controller.isLoadingInvoices.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.errorMessageInvoices.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: theme.colorScheme.error,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Failed to load invoices'.tr,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        controller.errorMessageInvoices.value,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 2.h),
                      ElevatedButton(
                        onPressed: () =>
                            controller.getPurchaseInvoices(refresh: true),
                        child: Text('Retry'.tr),
                      ),
                    ],
                  ),
                );
              }

              if (controller.invoices.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.5),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No invoices found'.tr,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Invoices will appear here once created'.tr,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshPurchaseInvoices,
                color: theme.colorScheme.primary,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: controller.invoices.length +
                      (controller.hasNext.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.invoices.length) {
                      // Loading indicator for next page
                      return Obx(() {
                        if (controller.isLoadingMore.value) {
                          return Container(
                            padding: EdgeInsets.all(4.w),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      });
                    }

                    final invoice = controller.invoices[index];
                    return InvoiceCardWidget(
                      invoice: invoice,
                      onTap: () {
                        Get.toNamed(AppPages.invoiceDetail, arguments: invoice);
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
