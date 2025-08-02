import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_assets.dart';
import 'package:teriak/config/themes/app_icon.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;
  final VoidCallback onAdjustStock;
  final VoidCallback onReorder;
  final VoidCallback onMarkExpired;
  final VoidCallback onLongPress;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAdjustStock,
    required this.onReorder,
    required this.onMarkExpired,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final int currentStock = (product['currentStock'] as num?)?.toInt() ?? 0;
    final int reorderPoint = (product['reorderPoint'] as num?)?.toInt() ?? 0;
    final DateTime? expiryDate = product['expiryDate'] != null
        ? DateTime.tryParse(product['expiryDate'].toString())
        : null;

    final bool isLowStock = currentStock <= reorderPoint;
    final bool isNearExpiry = expiryDate != null &&
        expiryDate.difference(DateTime.now()).inDays <= 30;
    final bool isExpired =
        expiryDate != null && expiryDate.isBefore(DateTime.now());

    return Dismissible(
      key: Key(product['id'].toString()),
      background: _buildSwipeBackground(context, isLeft: true),
      secondaryBackground: _buildSwipeBackground(context, isLeft: false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Swipe right - show details
          onTap();
        } else {
          // Swipe left - show actions
          _showQuickActions(context);
        }
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
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
                            product['name']?.toString() ?? 'Unknown Product'.tr,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            '${'Lot:'.tr} ${product['lotNumber']?.toString() ?? 'N/A'.tr}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadges(theme, colorScheme, isLowStock,
                        isNearExpiry, isExpired),
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
        child: product['imageUrl'] != null
            ? Image.asset(Assets.assetsImagesJustLogo)
            : Center(
                child: Image.asset(Assets.assetsImagesNoImage),
              ),
      ),
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
            Colors.orange,
            Colors.white,
          ),
        if (isLowStock) ...[
          if (isExpired || isNearExpiry) SizedBox(height: 0.5.h),
          _buildStatusBadge(
            theme,
            'LOW STOCK'.tr,
            Colors.red,
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
                ? Colors.red
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
          '\$${(product['unitPrice'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
        Text(
          '${'Total:'.tr} \$${((product['unitPrice'] as num? ?? 0) * (product['currentStock'] as num? ?? 0)).toStringAsFixed(2)}',
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
                  ? Colors.orange
                  : colorScheme.onSurface.withValues(alpha: 0.6),
          size: 4.w,
        ),
        SizedBox(width: 2.w),
        Text(
          isExpired
              ? '${'Expired'.tr} ${(-daysUntilExpiry)} ${'days ago'.tr}'
              : isNearExpiry
                  ? '${'Expires in'.tr} $daysUntilExpiry ${'days'.tr}'
                  : '${'Expires:'.tr} ${expiryDate.day}/${expiryDate.month}/${expiryDate.year}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: isExpired
                ? colorScheme.error
                : isNearExpiry
                    ? Colors.orange
                    : colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight:
                isExpired || isNearExpiry ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeBackground(BuildContext context, {required bool isLeft}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft ? colorScheme.primary : Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'info' : 'more_horiz',
                color: Colors.white,
                size: 8.w,
              ),
              SizedBox(height: 1.h),
              Text(
                isLeft ? 'Details'.tr : 'Actions'.tr,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBorderColor(ColorScheme colorScheme, bool isLowStock,
      bool isNearExpiry, bool isExpired) {
    if (isExpired) return colorScheme.error;
    if (isNearExpiry) return Colors.orange;
    if (isLowStock) return Colors.red;
    return colorScheme.outline.withValues(alpha: 0.2);
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Adjust Stock'.tr),
              onTap: () {
                Navigator.pop(context);
                onAdjustStock();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'shopping_cart',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Reorder'.tr),
              onTap: () {
                Navigator.pop(context);
                onReorder();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'warning',
                color: Colors.orange,
                size: 6.w,
              ),
              title: Text('Mark Expired'.tr),
              onTap: () {
                Navigator.pop(context);
                onMarkExpired();
              },
            ),
          ],
        ),
      ),
    );
  }
}
