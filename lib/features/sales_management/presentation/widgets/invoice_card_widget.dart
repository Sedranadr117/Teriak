import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

/// Individual invoice card widget displaying invoice summary information
/// Optimized for pharmacy staff quick browsing and selection
class InvoiceCardWidget extends StatelessWidget {
  final Map<String, dynamic> invoice;
  final VoidCallback? onTap;

  const InvoiceCardWidget({
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
    final String date = (invoice['invoiceDate'] as String?) ?? '';
    final double totalAmount =
        (invoice['totalAmount'] as num?)?.toDouble() ?? 0.0;
    final String paymentStatus = (invoice['status'] as String?) ?? 'unknown';
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
                        "فاتورة $customerName",
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
                    CustomIconWidget(
                      iconName: 'calendar_today',
                      size: 16,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      date,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    if (paymentMethod.isNotEmpty) ...[
                      SizedBox(width: 4.w),
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
                      'Total Amount'.tr,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    Text(
                      'SYP${totalAmount.toStringAsFixed(2)}',
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

  /// Builds payment status badge with appropriate color coding
  Widget _buildPaymentStatusBadge(BuildContext context, String status) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color badgeColor;
    Color textColor;
    String displayText;

    switch (status) {
      case 'COMPLETED':
        badgeColor = Colors.green;
        textColor = Colors.white;
        displayText = 'Paid'.tr;
        break;
      case 'pending':
        badgeColor = Colors.orange;
        textColor = Colors.white;
        displayText = 'Pending';
        break;
      case 'overdue':
        badgeColor = colorScheme.error;
        textColor = colorScheme.onError;
        displayText = 'Overdue';
        break;
      case 'partial':
        badgeColor = Colors.orange;
        textColor = Colors.white;
        displayText = 'Partial';
        break;
      default:
        badgeColor = colorScheme.outline;
        textColor = colorScheme.onSurface;
        displayText = 'Unknown';
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

  /// Gets appropriate icon for payment method
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
