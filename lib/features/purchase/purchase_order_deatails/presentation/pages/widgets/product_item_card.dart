import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class ProductItemCard extends StatelessWidget {
  final Map<String, dynamic> productData;
  final String currency;
  final VoidCallback? onLongPress;

  const ProductItemCard({
    super.key,
    required this.productData,
    required this.currency,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: InkWell(
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductImage(context),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productData['name'] as String? ?? 'منتج غير محدد',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),
                        if (productData['description'] != null) ...[
                          Text(
                            productData['description'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 1.h),
                        ],
                        _buildProductDetails(context),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              _buildPricingSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = productData['image'] as String?;

    return Container(
      width: 15.w,
      height: 15.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: imageUrl != null && imageUrl.isNotEmpty
          ? ClipRRect()
          : Center(
              child: CustomIconWidget(
                iconName: 'inventory_2',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                size: 24,
              ),
            ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        _buildDetailChip(
          context,
          'الكمية',
          _formatArabicNumber(productData['quantity']?.toString() ?? '0'),
          theme.colorScheme.secondary,
        ),
        SizedBox(width: 2.w),
        if (productData['unit'] != null)
          _buildDetailChip(
            context,
            'الوحدة',
            productData['unit'] as String,
            theme.colorScheme.tertiary,
          ),
      ],
    );
  }

  Widget _buildDetailChip(
      BuildContext context, String label, String value, Color color) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$label: $value',
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPricingSection(BuildContext context) {
    final theme = Theme.of(context);
    final unitPrice = _parsePrice(productData['unitPrice']);
    final quantity = _parseQuantity(productData['quantity']);
    final subtotal = unitPrice * quantity;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'سعر الوحدة',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              Text(
                '${_formatPrice(unitPrice)} ${_getCurrencySymbol(currency)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Divider(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
            height: 1,
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المجموع الفرعي',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                '${_formatPrice(subtotal)} ${_getCurrencySymbol(currency)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
