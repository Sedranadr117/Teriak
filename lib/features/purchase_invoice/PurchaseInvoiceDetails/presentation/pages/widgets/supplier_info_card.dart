import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class SupplierInfoCard extends StatelessWidget {
  final Map<String, dynamic> invoiceData;

  const SupplierInfoCard({
    super.key,
    required this.invoiceData,
  });


  void _showContactOptions(BuildContext context) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Contact ${invoiceData["supplierName"] ?? "Supplier"}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Call Supplier',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                invoiceData["supplierPhone"] ?? '+1 (555) 123-4567',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onTap: () {
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'email',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Email Supplier',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                invoiceData["supplierEmail"] ?? 'supplier@example.com',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onTap: () {
              
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'location_on',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'View Location',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                invoiceData["supplierAddress"] ??
                    '123 Business St, City, State',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onTap: () {
                Navigator.pop(context);
                // Location functionality would be implemented here
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencySymbol = invoiceData["currency"] ?? "\$";
    final totalAmount = invoiceData["totalAmount"] ?? 0.0;
    final exchangeRate = invoiceData["exchangeRate"] ?? 1.0;
    final localAmount = totalAmount * exchangeRate;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Supplier Name with Contact Action
            GestureDetector(
              onTap: () => _showContactOptions(context),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      invoiceData["supplierName"] ??
                          "Global Tech Supplies Ltd.",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'contact_phone',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),

            // Invoice Details Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invoice Date',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        invoiceData["date"] ?? "08/10/2025",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invoice Number',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        invoiceData["invoiceNumber"] ?? "INV-2025-001",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Amount Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '$currencySymbol${totalAmount.toStringAsFixed(2)}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                      fontFamily: 'monospace',
                    ),
                  ),
                  if (exchangeRate != 1.0) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      'Local: \$${localAmount.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 2.h),

            // Status and Currency Row
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(invoiceData["status"] ?? "paid")
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(invoiceData["status"] ?? "paid")
                          .withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName:
                            _getStatusIcon(invoiceData["status"] ?? "paid"),
                        color: _getStatusColor(invoiceData["status"] ?? "paid"),
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        (invoiceData["status"] ?? "paid")
                            .toString()
                            .toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              _getStatusColor(invoiceData["status"] ?? "paid"),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (currencySymbol != "\$")
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      currencySymbol,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'completed':
        return const Color(0xFF059669);
      case 'pending':
      case 'processing':
        return const Color(0xFFD97706);
      case 'overdue':
      case 'failed':
        return const Color(0xFFDC2626);
      case 'draft':
        return const Color(0xFF64748B);
      default:
        return const Color(0xFF64748B);
    }
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'completed':
        return 'check_circle';
      case 'pending':
      case 'processing':
        return 'schedule';
      case 'overdue':
      case 'failed':
        return 'error';
      case 'draft':
        return 'edit';
      default:
        return 'info';
    }
  }
}
