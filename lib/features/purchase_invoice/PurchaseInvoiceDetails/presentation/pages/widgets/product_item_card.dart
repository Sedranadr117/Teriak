import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class ProductItemCard extends StatefulWidget {
  final Map<String, dynamic> productData;
  final int index;

  const ProductItemCard({
    super.key,
    required this.productData,
    required this.index,
  });

  @override
  State<ProductItemCard> createState() => _ProductItemCardState();
}

class _ProductItemCardState extends State<ProductItemCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    HapticFeedback.lightImpact();
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _showItemActions(BuildContext context) {
    HapticFeedback.mediumImpact();

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
              widget.productData["productName"] ?? "Product Actions",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'inventory',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Check Inventory',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                'View current stock levels',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to inventory check
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Edit Item',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                'Modify quantity or details',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to edit item
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'info',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Product Details',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                'View complete product information',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onTap: () {
                Navigator.pop(context);
                // Navigate to product details
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Color _getStockStatusColor(String stockLevel) {
    switch (stockLevel.toLowerCase()) {
      case 'high':
      case 'in_stock':
        return const Color(0xFF059669);
      case 'medium':
      case 'low_stock':
        return const Color(0xFFD97706);
      case 'low':
      case 'out_of_stock':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF64748B);
    }
  }

  String _getStockStatusIcon(String stockLevel) {
    switch (stockLevel.toLowerCase()) {
      case 'high':
      case 'in_stock':
        return 'check_circle';
      case 'medium':
      case 'low_stock':
        return 'warning';
      case 'low':
      case 'out_of_stock':
        return 'error';
      default:
        return 'help';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productName = widget.productData["productName"] ?? "Unknown Product";
    final quantityReceived = widget.productData["quantityReceived"] ?? 0;
    final freeQuantity = widget.productData["freeQuantity"] ?? 0;
    final actualPrice = widget.productData["actualPrice"] ?? 0.0;
    final expiryDate = widget.productData["expiryDate"] ?? "N/A";
    final totalAmount = widget.productData["totalAmount"] ?? 0.0;
    final stockLevel = widget.productData["stockLevel"] ?? "medium";
    final productCode = widget.productData["productCode"] ?? "";
    final batchNumber = widget.productData["batchNumber"] ?? "";
    final manufacturer = widget.productData["manufacturer"] ?? "";

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main Product Info
          GestureDetector(
            onTap: _toggleExpansion,
            onLongPress: () => _showItemActions(context),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Stock Status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          productName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getStockStatusColor(stockLevel)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStockStatusColor(stockLevel)
                                .withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: _getStockStatusIcon(stockLevel),
                              color: _getStockStatusColor(stockLevel),
                              size: 12,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              stockLevel.toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: _getStockStatusColor(stockLevel),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Quantity and Price Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quantity Received',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                Text(
                                  quantityReceived.toString(),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                if (freeQuantity > 0) ...[
                                  SizedBox(width: 2.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 0.5.h),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.tertiary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '+$freeQuantity FREE',
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.tertiary,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Unit Price',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              '\$${actualPrice.toStringAsFixed(2)}',
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
                  SizedBox(height: 2.h),

                  // Total Amount and Expand Icon
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Amount',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              '\$${totalAmount.toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: CustomIconWidget(
                          iconName: 'expand_more',
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expanded Details
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    height: 1,
                  ),
                  SizedBox(height: 2.h),

                  // Additional Details Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailItem(
                          context,
                          'Expiry Date',
                          expiryDate,
                          'calendar_today',
                        ),
                      ),
                      Expanded(
                        child: _buildDetailItem(
                          context,
                          'Product Code',
                          productCode.isNotEmpty ? productCode : 'N/A',
                          'qr_code',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailItem(
                          context,
                          'Batch Number',
                          batchNumber.isNotEmpty ? batchNumber : 'N/A',
                          'numbers',
                        ),
                      ),
                      Expanded(
                        child: _buildDetailItem(
                          context,
                          'Manufacturer',
                          manufacturer.isNotEmpty ? manufacturer : 'N/A',
                          'business',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showItemActions(context),
                          icon: CustomIconWidget(
                            iconName: 'more_horiz',
                            color: theme.colorScheme.primary,
                            size: 16,
                          ),
                          label: Text('Actions'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to inventory check
                            HapticFeedback.lightImpact();
                          },
                          icon: CustomIconWidget(
                            iconName: 'inventory',
                            color: Colors.white,
                            size: 16,
                          ),
                          label: Text('Check Stock'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
      BuildContext context, String label, String value, String iconName) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              size: 16,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
