import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';

class OrderSummaryCard extends StatelessWidget {
  final double total;
  final String currency;
  final int itemCount;

  const OrderSummaryCard({
    super.key,
    required this.total,
    required this.currency,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            isDark ? AppColors.primaryDark : AppColors.primaryLight,
            isDark
                ? AppColors.primaryVariantDark
                : AppColors.primaryVariantLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  color: isDark
                      ? AppColors.onPrimaryDark
                      : AppColors.onPrimaryLight,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Order Total'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.onPrimaryDark
                        : AppColors.onPrimaryLight,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildSummaryDetails(),
            SizedBox(height: 12),
            _buildTotalSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryDetails() {
    return Column(
      children: [
        _buildSummaryRow(
          'Products List'.tr,
          '$itemCount ${itemCount == 1 ? 'item'.tr : 'items'.tr}',
        ),
        SizedBox(height: 0.8.h),
        _buildSummaryRow(
          'Currency'.tr,
          currency,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: (isDark
                        ? AppColors.onPrimaryDark
                        : AppColors.onPrimaryLight)
                    .withValues(alpha:0.9),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color:
                    isDark ? AppColors.onPrimaryDark : AppColors.onPrimaryLight,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTotalSection() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: 1.2.h,
            horizontal: 3.w,
          ),
          decoration: BoxDecoration(
            color: (isDark ? AppColors.onPrimaryDark : AppColors.onPrimaryLight)
                .withValues(alpha:0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount'.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.onPrimaryDark
                      : AppColors.onPrimaryLight,
                ),
              ),
              Flexible(
                child: Text(
                  '${total.toString()} $currency',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.onPrimaryDark
                        : AppColors.onPrimaryLight,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
