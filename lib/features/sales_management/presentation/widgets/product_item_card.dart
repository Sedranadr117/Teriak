import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class ProductItemCard extends StatefulWidget {
  final Map<String, dynamic> product;
  final bool isSelected;
  final int selectedQuantity;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Function(int)? onQuantityChanged;

  const ProductItemCard({
    super.key,
    required this.product,
    this.isSelected = false,
    this.selectedQuantity = 0,
    this.onTap,
    this.onLongPress,
    this.onQuantityChanged,
  });

  @override
  State<ProductItemCard> createState() => _ProductItemCardState();
}

class _ProductItemCardState extends State<ProductItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  // ignore: unused_field
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            elevation: widget.isSelected ? 4 : 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: widget.isSelected
                  ? BorderSide(color: colorScheme.primary, width: 2)
                  : BorderSide.none,
            ),
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onTap?.call();
              },
              onLongPress: () {
                HapticFeedback.mediumImpact();
                widget.onLongPress?.call();
              },
              onTapDown: (_) {
                setState(() => _isPressed = true);
                _animationController.forward();
              },
              onTapUp: (_) {
                setState(() => _isPressed = false);
                _animationController.reverse();
              },
              onTapCancel: () {
                setState(() => _isPressed = false);
                _animationController.reverse();
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product image
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colorScheme.surface.withValues(alpha: 0.5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          color: colorScheme.surface.withValues(alpha: 0.3),
                          child: CustomIconWidget(
                            iconName: 'medical_services',
                            color: theme.brightness == Brightness.light
                                ? const Color(0x99212121)
                                : const Color(0x99FFFFFF),
                            size: 6.w,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 3.w),

                    // Product details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product name and returnable badge
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.product["productName"] ??
                                      "Unknown Product",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              if ((widget.product["availableForRefund"]
                                          as int? ??
                                      0) >
                                  0)
                                _buildReturnableBadge(context),
                            ],
                          ),

                          SizedBox(height: 1.h),

                          // Quantity and unit price
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoChip(
                                  context,
                                  '${'Qty:'.tr} ${widget.product["quantity"] ?? 0}',
                                  CustomIconWidget(
                                    iconName: 'inventory',
                                    color: theme.brightness == Brightness.light
                                        ? const Color(0x99212121)
                                        : const Color(0x99FFFFFF),
                                    size: 4.w,
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: _buildInfoChip(
                                  context,
                                  'Sp ${(widget.product["unitPrice"] as double? ?? 0.0).toStringAsFixed(2)}',
                                  CustomIconWidget(
                                    iconName: 'attach_money',
                                    color: theme.brightness == Brightness.light
                                        ? const Color(0x99212121)
                                        : const Color(0x99FFFFFF),
                                    size: 4.w,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 1.h),

                          // Total price and quantity selector
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${'Total:'.tr} Sp ${(widget.product["subtotal"] as double? ?? 0.0)}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                ),
                              ),
                              if (widget.isSelected)
                                _buildQuantitySelector(context),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReturnableBadge(BuildContext context) {
    final theme = Theme.of(context);
    final int returnableQty = widget.product["availableForRefund"] as int? ?? 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.light
            ? const Color(0xFF4CAF50)
            : const Color(0xFF81C784),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${'Returnable:'.tr} $returnableQty',
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String text, Widget icon) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.light
            ? const Color(0xFFE0E0E0).withValues(alpha: 0.3)
            : const Color(0xFF424242).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: 1.w),
          Flexible(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final int maxQuantity = widget.product["availableForRefund"] as int? ?? 0;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.primary, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: widget.selectedQuantity > 0
                ? () {
                    HapticFeedback.lightImpact();
                    widget.onQuantityChanged?.call(widget.selectedQuantity - 1);
                  }
                : null,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            child: Container(
              width: 8.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: widget.selectedQuantity > 0
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : null,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: CustomIconWidget(
                iconName: 'remove',
                color: widget.selectedQuantity > 0
                    ? colorScheme.primary
                    : theme.brightness == Brightness.light
                        ? const Color(0x61212121)
                        : const Color(0x61FFFFFF),
                size: 4.w,
              ),
            ),
          ),
          Container(
            width: 12.w,
            height: 4.h,
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(color: colorScheme.primary, width: 1),
              ),
            ),
            child: Center(
              child: Text(
                '${widget.selectedQuantity}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: widget.selectedQuantity < maxQuantity
                ? () {
                    HapticFeedback.lightImpact();
                    widget.onQuantityChanged?.call(widget.selectedQuantity + 1);
                  }
                : null,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            child: Container(
              width: 8.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: widget.selectedQuantity < maxQuantity
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : null,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: CustomIconWidget(
                iconName: 'add',
                color: widget.selectedQuantity < maxQuantity
                    ? colorScheme.primary
                    : theme.brightness == Brightness.light
                        ? const Color(0x61212121)
                        : const Color(0x61FFFFFF),
                size: 4.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
