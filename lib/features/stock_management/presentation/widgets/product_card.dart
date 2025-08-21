import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;
  final VoidCallback onAdjustStock;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAdjustStock,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final int currentStock = (product['totalQuantity'] as num?)?.toInt() ?? 0;
    final int reorderPoint = (product['minStockLevel'] as num?)?.toInt() ?? 0;
    print("reorderPoint $reorderPoint");
    final DateTime? expiryDate = product['earliestExpiryDate'] != null
        ? DateTime.tryParse(product['earliestExpiryDate'].toString())
        : null;

    final bool isLowStock = currentStock <= reorderPoint;
    final bool isNearExpiry = expiryDate != null &&
        expiryDate.difference(DateTime.now()).inDays <= 30;
    final bool isExpired = product['hasExpiredItems'];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getBorderColor(
                colorScheme, isLowStock, isNearExpiry, isExpired),
            width: isLowStock || isNearExpiry || isExpired ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              offset: Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductImage(colorScheme),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['productName']?.toString() ??
                              'Unknown Product'.tr,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '${'Number of Batches:'.tr} ${product['numberOfBatches']?.toString() ?? 'N/A'.tr}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadges(
                      theme, colorScheme, isLowStock, isNearExpiry, isExpired),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStockInfo(
                      theme, colorScheme, currentStock, reorderPoint),
                  _buildPriceInfo(theme, colorScheme),
                ],
              ),
              if (expiryDate != null) ...[
                SizedBox(height: 1.h),
                _buildExpiryInfo(
                    theme, colorScheme, expiryDate, isNearExpiry, isExpired),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(ColorScheme colorScheme) {
    return Container(
      width: 15.w,
      height: 15.w,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: CustomIconWidget(
              iconName: 'medication',
              color: colorScheme.primary,
              size: 12.w,
            ),
          )),
    );
  }

  Widget _buildStatusBadges(ThemeData theme, ColorScheme colorScheme,
      bool isLowStock, bool isNearExpiry, bool isExpired) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isExpired)
          _buildStatusBadge(
            theme,
            'EXPIRED'.tr,
            colorScheme.error,
            colorScheme.onError,
          )
        else if (isNearExpiry)
          _buildStatusBadge(
            theme,
            'NEAR EXPIRY'.tr,
            AppColors.warningDark.withAlpha(220),
            Colors.white,
          ),
        if (isLowStock) ...[
          if (isExpired || isNearExpiry) SizedBox(height: 0.5.h),
          _buildStatusBadge(
            theme,
            'LOW STOCK'.tr,
            AppColors.errorLight.withAlpha(220),
            Colors.white,
          ),
        ],
      ],
    );
  }

  Widget _buildStatusBadge(
      ThemeData theme, String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 8.sp,
        ),
      ),
    );
  }

  Widget _buildStockInfo(ThemeData theme, ColorScheme colorScheme,
      int currentStock, int reorderPoint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Stock'.tr,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Text(
          '$currentStock ${'units'.tr}',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: currentStock <= reorderPoint
                ? AppColors.errorLight
                : colorScheme.onSurface,
          ),
        ),
        Text(
          '${'Reorder at:'.tr} $reorderPoint',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceInfo(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Unit Price'.tr,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Text(
          'SYP ${(product['sellingPrice'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
        Text(
          '${'Total:'.tr} SYP ${(product['totalValue'] as double? ?? 0.0).toStringAsFixed(2)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildExpiryInfo(ThemeData theme, ColorScheme colorScheme,
      DateTime expiryDate, bool isNearExpiry, bool isExpired) {
    final daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;

    return Row(
      children: [
        CustomIconWidget(
          iconName: 'schedule',
          color: isExpired
              ? colorScheme.error
              : isNearExpiry
                  ? AppColors.warningDark.withAlpha(220)
                  : colorScheme.onSurface.withValues(alpha: 0.6),
          size: 4.w,
        ),
        SizedBox(width: 2.w),
        Text(
          isExpired
              ? '${'أقرب دفعة انتهت'.tr} ${(-daysUntilExpiry)} ${'days ago'.tr}'
              : isNearExpiry
                  ? '${'اقرب دفعة تنتهي عند'.tr} $daysUntilExpiry ${'days'.tr}'
                  : '${'اقرب دفعة تنتهي عند:'.tr} ${expiryDate.day}/${expiryDate.month}/${expiryDate.year}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: isExpired
                ? colorScheme.error
                : isNearExpiry
                    ? AppColors.warningDark.withAlpha(220)
                    : colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight:
                isExpired || isNearExpiry ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Color _getBorderColor(ColorScheme colorScheme, bool isLowStock,
      bool isNearExpiry, bool isExpired) {
    if (isExpired) return colorScheme.error;
    if (isNearExpiry) return AppColors.warningLight.withOpacity(0.4);
    if (isLowStock) return AppColors.errorLight.withOpacity(0.4);
    return colorScheme.outline.withValues(alpha: 0.2);
  }
}
