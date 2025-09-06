import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:sizer/sizer.dart';

class InvoiceHeaderCard extends StatelessWidget {
  final Map<String, dynamic> invoiceData;

  const InvoiceHeaderCard({
    super.key,
    required this.invoiceData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
            // Invoice title/date and status chips
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${'Invoice'.tr} #${invoiceData["customerName"] ?? "N/A"}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  invoiceData["invoiceDate"] ??
                      invoiceData["refundDate"].toString() ??
                      "N/A",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.brightness == Brightness.light
                        ? const Color(0x99212121)
                        : const Color(0x99FFFFFF),
                  ),
                ),
                SizedBox(height: 1.2.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: [
                      _buildPaymentStatusBadge(context),
                      if (((invoiceData["refundStatus"] as String?) ?? '')
                          .trim()
                          .isNotEmpty) ...[
                        _buildRefundStatusBadge(context),
                      ]
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Customer information
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.brightness == Brightness.light
                      ? const Color(0xFFE0E0E0)
                      : const Color(0xFF424242),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer Information'.tr,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  _buildCustomerInfoRow(
                    context,
                    'Name'.tr,
                    invoiceData["customerName"] ?? "N/A",
                  ),
                  SizedBox(height: 0.5.h),
                  _buildCustomerInfoRow(
                    context,
                    'Payment Method'.tr,
                    invoiceData["paymentMethod"] ?? "N/A",
                  ),
                  if (((invoiceData["refundReason"] as String?) ?? '')
                      .trim()
                      .isNotEmpty) ...[
                    SizedBox(height: 0.5.h),
                    _buildCustomerInfoRow(
                      context,
                      'Refund reason'.tr,
                      invoiceData["refundReason"],
                      isHighlight: false,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStatusBadge(BuildContext context) {
    final theme = Theme.of(context);
    final String status = invoiceData["paymentStatus"] ?? "Unknown".tr;
    final colorScheme = theme.colorScheme;

    Color badgeColor;
    Color textColor;
    String displayText;
    IconData iconData;

    switch (status) {
      case 'FULLY_PAID':
        badgeColor = Colors.green;
        textColor = Colors.green.shade900;
        displayText = 'Paid'.tr;
        iconData = Icons.check_circle_rounded;
        break;
      case 'UNPAID':
        badgeColor = Colors.orange;
        textColor = Colors.orange.shade900;
        displayText = 'Pending'.tr;
        iconData = Icons.hourglass_bottom_rounded;
        break;
      case 'OVERDUE':
        badgeColor = colorScheme.error;
        textColor = colorScheme.error;
        displayText = 'Overdue'.tr;
        iconData = Icons.error_rounded;
        break;
      case 'PARTIALLY_PAID':
        badgeColor = const Color(0xFFFFD54F);
        textColor = const Color(0xFF8A6D00);
        displayText = 'Partial'.tr;
        iconData = Icons.payments_rounded;
        break;
      default:
        badgeColor = colorScheme.outline;
        textColor = colorScheme.onSurfaceVariant;
        displayText = 'Unknown'.tr;
        iconData = Icons.help_outline_rounded;
    }

    return _buildStatusChip(
      context,
      backgroundColor: badgeColor.withOpacity(0.12),
      borderColor: badgeColor.withOpacity(0.24),
      iconColor: badgeColor,
      textColor: textColor,
      icon: iconData,
      label: displayText,
    );
  }

  Widget _buildRefundStatusBadge(BuildContext context) {
    final theme = Theme.of(context);
    final String status = invoiceData["refundStatus"] ?? "Unknown".tr;
    final colorScheme = theme.colorScheme;

    Color badgeColor;
    Color textColor;
    String displayText;
    IconData iconData;

    switch (status) {
      case 'FULLY_REFUNDED':
        badgeColor = Colors.green;
        textColor = Colors.green.shade900;
        displayText = 'Fully refunded'.tr;
        iconData = Icons.undo_rounded;
        break;
      case 'NO_REFUND':
        badgeColor = Colors.orange;
        textColor = Colors.orange.shade900;
        displayText = 'No refund'.tr;
        iconData = Icons.block_rounded;
        break;
      case 'PARTIALLY_REFUNDED':
        badgeColor = const Color(0xFFFFD54F);
        textColor = const Color(0xFF8A6D00);
        displayText = 'Partially refunded'.tr;
        iconData = Icons.undo;
        break;
      default:
        badgeColor = colorScheme.outline;
        textColor = colorScheme.onSurfaceVariant;
        displayText = 'Unknown'.tr;
        iconData = Icons.help_outline_rounded;
    }

    return _buildStatusChip(
      context,
      backgroundColor: badgeColor.withOpacity(0.12),
      borderColor: badgeColor.withOpacity(0.24),
      iconColor: badgeColor,
      textColor: textColor,
      icon: iconData,
      label: displayText,
    );
  }

  Widget _buildStatusChip(
    BuildContext context, {
    required Color backgroundColor,
    required Color borderColor,
    required Color iconColor,
    required Color textColor,
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.9.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          SizedBox(width: 1.5.w),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 30.w,
          child: Text(
            '$label:',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.brightness == Brightness.light
                  ? const Color(0x99212121)
                  : const Color(0x99FFFFFF),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w400,
              color: isHighlight
                  ? (theme.brightness == Brightness.light
                      ? const Color(0xFFF44336)
                      : const Color(0xFFCF6679))
                  : null,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
