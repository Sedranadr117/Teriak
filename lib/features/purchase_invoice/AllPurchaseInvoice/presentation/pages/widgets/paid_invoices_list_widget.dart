import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_icon.dart';

class PaidInvoicesListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> invoices;
  final Function(Map<String, dynamic>) onInvoiceSelected;
  final bool isRefreshing;

  const PaidInvoicesListWidget({
    super.key,
    required this.invoices,
    required this.onInvoiceSelected,
    this.isRefreshing = false,
  });

  String _formatCurrency(double amount, String currency) {
    final formatter = NumberFormat('#,##0.00');
    final currencySymbol = _getCurrencySymbol(currency);
    return '$currencySymbol${formatter.format(amount)}';
  }

  String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'SAR':
        return 'ر.س ';
      case 'AED':
        return 'د.إ ';
      default:
        return '$currency ';
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Color _getStatusColor(String status, ThemeData theme) {
    switch (status.toLowerCase()) {
      case 'مدفوع':
        return theme.colorScheme.tertiary;
      case 'معلق':
        return Colors.orange;
      case 'ملغي':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.onSurface.withValues(alpha: 0.6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isRefreshing) {
      return Container(
          height: 30.h,
          child: const Center(child: CircularProgressIndicator()));
    }

    if (invoices.isEmpty) {
      return Container(
          width: double.infinity,
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: 1)),
          child: Column(children: [
            CustomIconWidget(
                iconName: 'receipt_long',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                size: 64),
            SizedBox(height: 2.h),
            Text('لا توجد فواتير مدفوعة',
                style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600)),
            SizedBox(height: 1.h),
            Text('ستظهر الفواتير المدفوعة هنا بعد إكمال عملية الدفع',
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                textAlign: TextAlign.center),
          ]));
    }

    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: invoices.length,
        separatorBuilder: (context, index) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          final invoice = invoices[index];

          return InkWell(
              onTap: () {
                Get.toNamed(
                  AppPages.invoiceDetail,
                  arguments: invoice,
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color:
                              theme.colorScheme.outline.withValues(alpha: 0.3),
                          width: 1),
                      boxShadow: [
                        BoxShadow(
                            color: theme.shadowColor.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2)),
                      ]),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Row(children: [
                                Container(
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                        color: theme.colorScheme.primary
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: CustomIconWidget(
                                        iconName: 'receipt_long',
                                        color: theme.colorScheme.primary,
                                        size: 20)),
                                SizedBox(width: 3.w),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text(invoice['invoiceNumber'],
                                          style: theme.textTheme.titleSmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: theme
                                                      .colorScheme.primary)),
                                      SizedBox(height: 0.5.h),
                                      Text(invoice['supplier'],
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis),
                                    ])),
                              ])),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                      color: _getStatusColor(
                                              invoice['status'], theme)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Text(invoice['status'],
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                              color: _getStatusColor(
                                                  invoice['status'], theme),
                                              fontWeight: FontWeight.w600))),
                            ]),

                        SizedBox(height: 2.h),

                        // Details Row
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Date
                              Row(children: [
                                CustomIconWidget(
                                    iconName: 'calendar_today',
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                    size: 16),
                                SizedBox(width: 1.w),
                                Text(_formatDate(invoice['date']),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.7))),
                              ]),

                              // Payment Date
                              Row(children: [
                                CustomIconWidget(
                                    iconName: 'payment',
                                    color: theme.colorScheme.tertiary
                                        .withValues(alpha: 0.8),
                                    size: 16),
                                SizedBox(width: 1.w),
                                Text(
                                    'دُفع في ${_formatDate(invoice['paymentDate'])}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.tertiary
                                            .withValues(alpha: 0.8),
                                        fontWeight: FontWeight.w500)),
                              ]),
                            ]),

                        SizedBox(height: 1.h),

                        // Amount and Action Row
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  _formatCurrency(invoice['totalAmount'],
                                      invoice['currency']),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: theme.colorScheme.primary)),
                              Row(children: [
                                Text('عرض التفاصيل',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(width: 1.w),
                                CustomIconWidget(
                                    iconName: 'arrow_forward_ios',
                                    color: theme.colorScheme.primary,
                                    size: 14),
                              ]),
                            ]),
                      ])));
        });
  }
}
