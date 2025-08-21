import 'package:flutter/material.dart';
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
            // Invoice number and date row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invoice #${invoiceData["customerName"] ?? "N/A"}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        invoiceData["invoiceDate"] ?? "N/A",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.brightness == Brightness.light
                              ? const Color(0x99212121)
                              : const Color(0x99FFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildPaymentStatusBadge(context),
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
                    'Customer Information',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  _buildCustomerInfoRow(
                    context,
                    'Name',
                    invoiceData["customerName"] ?? "N/A",
                  ),
                  SizedBox(height: 0.5.h),
                  _buildCustomerInfoRow(
                    context,
                    'Payment Method',
                    invoiceData["paymentMethod"] ?? "N/A",
                  ),
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
    final String status = invoiceData["status"] ?? "Unknown";
    final colorScheme = theme.colorScheme;

    Color badgeColor;
    Color textColor;
    String displayText;

    switch (status) {
      case 'COMPLETED':
        badgeColor = Colors.green;
        textColor = Colors.white;
        displayText = 'Paid';
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
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        displayText,
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
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
