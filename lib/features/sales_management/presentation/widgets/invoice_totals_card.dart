import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class InvoiceTotalsCard extends StatelessWidget {
  final Map<String, dynamic> invoiceData;

  const InvoiceTotalsCard({
    super.key,
    required this.invoiceData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final double subtotal = invoiceData["subtotal"] as double? ?? 0.0;
    final double tax = invoiceData["tax"] as double? ?? 0.0;
    final double discount = invoiceData["discount"] as double? ?? 0.0;
    final double total = invoiceData["total"] as double? ?? 0.0;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice Summary'.tr,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 2.h),

            // Subtotal
            _buildTotalRow(
              context,
              'Subtotal'.tr,
              subtotal,
              isSubtotal: true,
            ),

            SizedBox(height: 1.h),

            // Tax
            _buildTotalRow(
              context,
              'Tax'.tr,
              tax,
              isTax: true,
            ),

            SizedBox(height: 1.h),

            // Discount (if applicable)
            if (discount > 0) ...[
              _buildTotalRow(
                context,
                'Discount'.tr,
                -discount,
                isDiscount: true,
              ),
              SizedBox(height: 1.h),
            ],

            // Divider
            Container(
              height: 1,
              width: double.infinity,
              color: theme.brightness == Brightness.light
                  ? const Color(0xFFE0E0E0)
                  : const Color(0xFF424242),
              margin: EdgeInsets.symmetric(vertical: 1.h),
            ),

            // Total
            _buildTotalRow(
              context,
              'Total Amount'.tr,
              total,
              isTotal: true,
            ),

            SizedBox(height: 2.h),

            // Payment method and status
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName:
                        _getPaymentMethodIcon(invoiceData["paymentMethod"]),
                    color: colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Method'.tr,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.brightness == Brightness.light
                                ? const Color(0x99212121)
                                : const Color(0x99FFFFFF),
                          ),
                        ),
                        Text(
                          invoiceData["paymentMethod"] ?? "N/A".tr,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildPaymentStatusIndicator(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(
    BuildContext context,
    String label,
    double amount, {
    bool isSubtotal = false,
    bool isTax = false,
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    TextStyle? labelStyle;
    TextStyle? amountStyle;

    if (isTotal) {
      labelStyle = theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      );
      amountStyle = theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: colorScheme.primary,
      );
    } else if (isDiscount) {
      labelStyle = theme.textTheme.bodyMedium;
      amountStyle = theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: theme.brightness == Brightness.light
            ? const Color(0xFF4CAF50)
            : const Color(0xFF81C784),
      );
    } else if (isTax) {
      labelStyle = theme.textTheme.bodyMedium;
      amountStyle = theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: theme.brightness == Brightness.light
            ? const Color(0xFFFF9800)
            : const Color(0xFFFFB74D),
      );
    } else {
      labelStyle = theme.textTheme.bodyMedium;
      amountStyle = theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(
          '\$${amount.abs().toStringAsFixed(2)}',
          style: amountStyle,
        ),
      ],
    );
  }

  Widget _buildPaymentStatusIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final String status = invoiceData["paymentStatus"] ?? "Unknown".tr;

    Color indicatorColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'paid':
        indicatorColor = theme.brightness == Brightness.light
            ? const Color(0xFF4CAF50)
            : const Color(0xFF81C784);
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        indicatorColor = theme.brightness == Brightness.light
            ? const Color(0xFFFF9800)
            : const Color(0xFFFFB74D);
        statusIcon = Icons.schedule;
        break;
      case 'overdue':
        indicatorColor = theme.brightness == Brightness.light
            ? const Color(0xFFF44336)
            : const Color(0xFFCF6679);
        statusIcon = Icons.warning;
        break;
      default:
        indicatorColor = theme.brightness == Brightness.light
            ? const Color(0xFF9E9E9E)
            : const Color(0xFF616161);
        statusIcon = Icons.help_outline;
    }

    return Container(
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: indicatorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: CustomIconWidget(
        iconName: _getIconName(statusIcon),
        color: indicatorColor,
        size: 5.w,
      ),
    );
  }

  String _getPaymentMethodIcon(String? paymentMethod) {
    switch (paymentMethod?.toLowerCase()) {
      case 'cash':
        return 'payments';
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

  String _getIconName(IconData iconData) {
    if (iconData == Icons.check_circle) return 'check_circle';
    if (iconData == Icons.schedule) return 'schedule';
    if (iconData == Icons.warning) return 'warning';
    return 'help_outline';
  }
}
