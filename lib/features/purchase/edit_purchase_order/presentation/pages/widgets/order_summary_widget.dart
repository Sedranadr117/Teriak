import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class OrderSummaryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final String currency;
  final bool isRTL;

  const OrderSummaryWidget({
    super.key,
    required this.products,
    required this.currency,
    this.isRTL = false,
  });

  double get _subtotal {
    return products.fold(0.0, (sum, product) {
      return sum + ((product['totalPrice'] as double?) ?? 0.0);
    });
  }

  double get _tax {
    return _subtotal * 0.1; // 10% tax
  }

  double get _total {
    return _subtotal + _tax;
  }

  String get _currencySymbol {
    return currency == 'USD' ? '\$' : 'ل.س';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'receipt_long',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  isRTL ? 'ملخص الطلب' : 'Order Summary',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${products.length} ${isRTL ? 'منتج' : 'items'}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Summary Details
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                // Subtotal
                _buildSummaryRow(
                  context,
                  label: isRTL ? 'المجموع الفرعي' : 'Subtotal',
                  value: '$_currencySymbol${_subtotal.toStringAsFixed(2)}',
                  isSubtotal: true,
                ),

                SizedBox(height: 1.h),

                // Tax
                _buildSummaryRow(
                  context,
                  label: isRTL ? 'الضريبة (10%)' : 'Tax (10%)',
                  value: '$_currencySymbol${_tax.toStringAsFixed(2)}',
                ),

                SizedBox(height: 1.h),

                // Divider
                Divider(
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                  thickness: 1,
                ),

                SizedBox(height: 1.h),

                // Total
                _buildSummaryRow(
                  context,
                  label: isRTL ? 'المجموع الكلي' : 'Total',
                  value: '$_currencySymbol${_total.toStringAsFixed(2)}',
                  isTotal: true,
                ),

                SizedBox(height: 2.h),

                // Currency Info
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'info_outline',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          isRTL
                              ? 'العملة: ${currency == 'USD' ? 'دولار أمريكي' : 'ليرة سورية'}'
                              : 'Currency: ${currency == 'USD' ? 'US Dollar' : 'Syrian Pound'}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required String label,
    required String value,
    bool isSubtotal = false,
    bool isTotal = false,
  }) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                )
              : theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSubtotal ? FontWeight.w600 : FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
        ),
        Text(
          value,
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                )
              : theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
        ),
      ],
    );
  }
}
