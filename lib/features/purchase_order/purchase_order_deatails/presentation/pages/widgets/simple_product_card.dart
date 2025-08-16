import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';

class SimpleProductCard extends StatelessWidget {
  final Map<String, dynamic> productData;
  final String currency;

  const SimpleProductCard({
    super.key,
    required this.productData,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final productName =
        (productData['name'] as String?) ?? 'Unknown Product'.tr;
    final quantity = (productData['quantity'] as num?) ?? 0;
    final unitPrice = (productData['unitPrice'] as num?) ?? 0;
    final barcode = (productData['barcode'] as String?) ?? 'N/A'.tr;
    final productType = (productData['type'] as String?) ?? 'Unknown'.tr;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Name
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'medication',
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    productName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Product Details Row
            Row(
              children: [
                // Quantity and Price Column
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        context,
                        'Quantity'.tr,
                        quantity.toString(),
                        Icons.inventory_2_outlined,
                      ),
                      SizedBox(height: 1.h),
                      _buildDetailRow(
                        context,
                        'Unit Price'.tr,
                        _formatAmount(unitPrice.toDouble(), currency),
                        Icons.attach_money,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 4.w),

                // Barcode and Type Column
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        context,
                        'Barcode'.tr,
                        barcode,
                        Icons.qr_code,
                      ),
                      SizedBox(height: 1.h),
                      _buildDetailRow(
                        context,
                        'Product Type'.tr,
                        productType,
                        Icons.category_outlined,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 1.h),

            // Total Price
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
              decoration: BoxDecoration(
                color: AppColors.successLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.successLight.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total'.tr,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.successLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _formatAmount((quantity * unitPrice).toDouble(), currency),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: AppColors.successLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatAmount(double amount, String currency) {
    final formattedAmount = amount.toStringAsFixed(2);
    return currency == 'USD'
        ? '\$${formattedAmount}'
        : '${formattedAmount} ل.س';
  }
}
