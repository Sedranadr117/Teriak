import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/sales_management/data/models/refund_model.dart';
import 'package:teriak/features/sales_management/presentation/controllers/sale_controller.dart';
import 'package:teriak/features/sales_management/presentation/widgets/refund_card_widget.dart';

class RefundsListScreen extends StatefulWidget {
  const RefundsListScreen({super.key});

  @override
  State<RefundsListScreen> createState() => _RefundsListScreenState();
}

class _RefundsListScreenState extends State<RefundsListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late SaleController saleController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    saleController = Get.put(SaleController(customerTag: ''), tag: '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      saleController.fetchRefunds();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Returned sales invoices'.tr),
        actions: [
          IconButton(
            onPressed: saleController.refreshRefund,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: Theme.of(context).colorScheme.onSurface,
              size: 6.w,
            ),
            tooltip: 'Refresh Stock'.tr,
          ),
        ],
      ),
      body: Obx(() {
        if (saleController.isLoading.value) {
          return _buildLoadingIndicator();
        }
        if (saleController.refunds.isEmpty) {
          return Center(
            child: _buildEmptyState(),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            saleController.refreshRefund();
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: saleController.refunds.length,
            itemBuilder: (context, index) {
              if (index >= saleController.refunds.length) {
                return _buildLoadingIndicator();
              }
              final invoice = saleController.refunds[index];
              return RefundCardWidget(
                invoice: {
                  'refundItems': invoice.refundedItems
                      .map((e) => (e as RefundItemModel).toJson())
                      .toList(),
                  'refundReason': invoice.refundReason,
                  'totalRefundAmount': invoice.totalRefundAmount,
                  "customerName": invoice.customerName,
                  "paymentMethod": invoice.paymentMethod,
                  "refundDate": invoice.refundDate,
                  "refundStatus": invoice.refundStatus,
                },
                onTap: () => _onInvoiceTap(
                  {
                    'refundItems': invoice.refundedItems
                        .map((e) => (e as RefundItemModel).toJson())
                        .toList(),
                    'refundReason': invoice.refundReason,
                    'totalRefundAmount': invoice.totalRefundAmount,
                    "customerName": invoice.customerName,
                    "paymentMethod": invoice.paymentMethod,
                    "refundDate": invoice.refundDate,
                    "refundStatus": invoice.refundStatus
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _onInvoiceTap(Map<String, dynamic> invoice) {
    Get.toNamed(AppPages.refundsDetails, arguments: invoice);
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String messageTitle = 'No invoices available'.tr;
    final String messageBody = 'Invoices will appear here when available'.tr;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'receipt_long',
              size: 64,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
            SizedBox(height: 2.h),
            Text(
              messageTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              messageBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
