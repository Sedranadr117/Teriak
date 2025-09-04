import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class RefundCardWidget extends StatelessWidget {
  final Map<String, dynamic> invoice;
  final VoidCallback? onTap;

  const RefundCardWidget({
    super.key,
    required this.invoice,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String customerName =
        (invoice['customerName'] as String?) ?? 'Unknown Customer';
    final double totalAmount = invoice['totalRefundAmount'];
    final String paymentStatus =
        (invoice['paymentStatus'] as String?) ?? 'unknown';
    final String paymentMethod = (invoice['paymentMethod'] as String?) ?? '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap?.call();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.05),
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconWidget(
                      iconName: 'person_outline',
                      size: 16,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    Expanded(
                      child: Text(
                        "${"invoice".tr} $customerName",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    _buildPaymentStatusBadge(context, paymentStatus),
                  ],
                ),

                SizedBox(height: 0.5.h),

                // Date and payment method
                Row(
                  children: [
                    if (paymentMethod.isNotEmpty) ...[
                      CustomIconWidget(
                        iconName: _getPaymentMethodIcon(paymentMethod),
                        size: 16,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        paymentMethod,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ],
                ),

                SizedBox(height: 1.h),

                // Total amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Refund Amount'.tr,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    Text(
                      '+  Sp ${totalAmount.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentStatusBadge(BuildContext context, String status) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color badgeColor;
    Color textColor;
    String displayText;

    switch (status) {
      case 'FULLY_PAID':
        badgeColor = Colors.green;
        textColor = Colors.white;
        displayText = 'Paid'.tr;
        break;
      case 'UNPAID':
        badgeColor = Colors.orange;
        textColor = Colors.white;
        displayText = 'Pending'.tr;
        break;
      case 'OVERDUE':
        badgeColor = colorScheme.error;
        textColor = colorScheme.onError;
        displayText = 'Overdue';
        break;
      case 'PARTIALLY_PAID':
        badgeColor = Color(0xFFFFD54F);
        textColor = Colors.white;
        displayText = 'Partial'.tr;
        break;
      default:
        badgeColor = colorScheme.outline;
        textColor = colorScheme.onSurface;
        displayText = 'Unknown'.tr;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getPaymentMethodIcon(String paymentMethod) {
    switch (paymentMethod.toLowerCase()) {
      case 'cash':
        return 'payments';
      case 'card':
      case 'credit card':
      case 'debit card':
        return 'credit_card';
      case 'insurance':
        return 'local_hospital';
      case 'check':
        return 'receipt';
      default:
        return 'payment';
    }
  }
}
