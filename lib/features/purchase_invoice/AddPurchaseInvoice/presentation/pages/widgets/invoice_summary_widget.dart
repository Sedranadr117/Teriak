import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/presentation/controller/all_purchase_invoice_controller.dart';

class InvoiceSummaryWidget extends StatefulWidget {
  final int totalReceivedItems;
  final int totalBonusItems;
  final double totalAmount;
  final bool isSaving;
  final String currency;

  final VoidCallback onProceedToPayment;

  const InvoiceSummaryWidget({
    super.key,
    required this.totalReceivedItems,
    required this.totalBonusItems,
    required this.totalAmount,
    required this.isSaving,
    required this.currency,
    required this.onProceedToPayment,

  });

  @override
  State<InvoiceSummaryWidget> createState() => _InvoiceSummaryWidgetState();
}

class _InvoiceSummaryWidgetState extends State<InvoiceSummaryWidget> {
  final allController = Get.find<AllPurchaseInvoiceController>();
  @override
  void didUpdateWidget(InvoiceSummaryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.totalAmount != widget.totalAmount ||
        oldWidget.totalReceivedItems != widget.totalReceivedItems ||
        oldWidget.totalBonusItems != widget.totalBonusItems) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'calculate',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Invoice Summary'.tr,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Quick Stats Row - Smaller size
          Row(
            children: [
              Expanded(
                child: _buildSmallStatCard(
                  context,
                  'Received Items'.tr,
                  widget.totalReceivedItems.toString(),
                  'inventory_2',
                  theme.colorScheme.tertiary,
                ),
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: _buildSmallStatCard(
                  context,
                  'Bonus Items'.tr,
                  widget.totalBonusItems.toString(),
                  'redeem',
                  theme.colorScheme.tertiary,
                ),
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: _buildSmallStatCard(
                  context,
                  'Total Items'.tr,
                  (widget.totalReceivedItems + widget.totalBonusItems)
                      .toString(),
                  'widgets',
                  theme.colorScheme.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Calculation Breakdown
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                SizedBox(height: 0.5.h),
                _buildSmallCalculationRow(
                  context,
                  'Total Amount'.tr,
                  widget.totalAmount,
                  true,
                  widget.currency
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Continue to Payment Button - Smaller width
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.isSaving ? null : widget.onProceedToPayment,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: widget.isSaving
                  ? SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'payment',
                          color: theme.colorScheme.onPrimary,
                          size: 18,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Continue to Payment'.tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStatCard(
    BuildContext context,
    String title,
    String value,
    String iconName,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(1.5.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 16,
          ),
          SizedBox(height: 0.3.h),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 9.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCalculationRow(
    BuildContext context,
    String label,
    double amount,
    bool isTotal,
    String currency,
  ) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                )
              : theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
        ),
        Flexible(
          child: Text(
            '${currency}${amount.toString()}'
          ,
            style: isTotal
                ? theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  )
                : theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
          ),
        ),
      ],
    );
  }
}
