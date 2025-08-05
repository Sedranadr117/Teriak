import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class TotalAmountCard extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final String currency;

  const TotalAmountCard({
    super.key,
    required this.products,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalAmount = _calculateTotalAmount();

    return Container(
      margin: EdgeInsets.all(4.w),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'إجمالي الطلبية',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '${_formatArabicNumber(products.length.toString())} منتج',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimary
                                .withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                    CustomIconWidget(
                      iconName: 'receipt_long',
                      color: theme.colorScheme.onPrimary,
                      size: 32,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المبلغ الإجمالي',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_formatPrice(totalAmount)} ${_getCurrencySymbol(currency)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
                _buildSummaryRow(
                  context,
                  'عدد المنتجات',
                  _formatArabicNumber(products.length.toString()),
                  theme.colorScheme.onPrimary,
                ),
                SizedBox(height: 1.h),
                _buildSummaryRow(
                  context,
                  'إجمالي الكمية',
                  _formatArabicNumber(_calculateTotalQuantity().toString()),
                  theme.colorScheme.onPrimary,
                ),
                SizedBox(height: 1.h),
                _buildSummaryRow(
                  context,
                  'متوسط سعر الوحدة',
                  '${_formatPrice(_calculateAveragePrice())} ${_getCurrencySymbol(currency)}',
                  theme.colorScheme.onPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
      BuildContext context, String label, String value, Color textColor) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: textColor.withValues(alpha: 0.8),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  double _calculateTotalAmount() {
    double total = 0.0;
    for (final product in products) {
      final unitPrice = _parsePrice(product['unitPrice']);
      final quantity = _parseQuantity(product['quantity']);
      total += unitPrice * quantity;
    }
    return total;
  }

  int _calculateTotalQuantity() {
    int total = 0;
    for (final product in products) {
      total += _parseQuantity(product['quantity']);
    }
    return total;
  }

  double _calculateAveragePrice() {
    if (products.isEmpty) return 0.0;

    double totalPrice = 0.0;
    for (final product in products) {
      totalPrice += _parsePrice(product['unitPrice']);
    }
    return totalPrice / products.length;
  }

  double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is double) return price;
    if (price is int) return price.toDouble();
    if (price is String) {
      final cleanPrice = price.replaceAll(RegExp(r'[^\d.]'), '');
      return double.tryParse(cleanPrice) ?? 0.0;
    }
    return 0.0;
  }

  int _parseQuantity(dynamic quantity) {
    if (quantity == null) return 0;
    if (quantity is int) return quantity;
    if (quantity is double) return quantity.toInt();
    if (quantity is String) {
      return int.tryParse(quantity.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
    }
    return 0;
  }

  String _formatPrice(double price) {
    return _formatArabicNumber(price.toStringAsFixed(2));
  }

  String _formatArabicNumber(String number) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String result = number;

    for (int i = 0; i < 10; i++) {
      result = result.replaceAll(i.toString(), arabicDigits[i]);
    }

    return result;
  }

  String _getCurrencySymbol(String currency) {
    switch (currency.toLowerCase()) {
      case 'syp':
      case 'syrian pound':
        return 'ل.س';
      case 'usd':
      case 'us dollar':
        return '\$';
      default:
        return currency;
    }
  }
}
