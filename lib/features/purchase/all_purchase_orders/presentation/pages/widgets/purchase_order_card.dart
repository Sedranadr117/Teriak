import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/purchase/all_purchase_orders/domain/entities/purchase_entity .dart';

class PurchaseOrderCard extends StatelessWidget {
  final PurchaseOrderEntity orderData;
  final VoidCallback onTap;

  const PurchaseOrderCard({
    super.key,
    required this.orderData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final supplierName =
        (orderData.supplierName as String?) ?? " ";
    final totalAmount = (orderData.total as double?) ?? 0.0;
    final currency = (orderData.currency as String?) ?? ' ';
    final status = (orderData.status as String?) ?? ' ';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Name and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      supplierName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusBadge(context, status),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Total Amount
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'attach_money',
                        size: 16,
                        color: AppColors.successLight,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        _formatAmount(totalAmount, currency),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.successLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    final theme = Theme.of(context);
    Color badgeColor;
    String statusText;

    switch (status) {
      case 'DONE':
        badgeColor = AppColors.successLight;
        statusText = 'Completed'.tr;
        break;
      case 'PENDING':
        badgeColor = AppColors.warningLight;
        statusText = 'Pending'.tr;
        break;
      case 'CANCELLED':
        badgeColor = AppColors.errorLight;
        statusText = 'Cancelled'.tr;
        break;
      default:
        badgeColor = theme.colorScheme.primary;
        statusText = 'New Order'.tr;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        statusText,
        style: theme.textTheme.labelSmall?.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatAmount(double amount, String currency) {
    final formattedAmount = amount.toStringAsFixed(2);
    return currency == 'USD'
        ? '\$${formattedAmount}'
        : '${formattedAmount} ل.س';
  }
}
