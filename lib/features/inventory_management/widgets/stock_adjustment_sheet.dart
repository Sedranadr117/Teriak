import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_assets.dart';

import 'package:teriak/config/themes/app_icon.dart';

class StockAdjustmentSheet extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>) onAdjustmentSubmitted;

  const StockAdjustmentSheet({
    super.key,
    required this.product,
    required this.onAdjustmentSubmitted,
  });

  @override
  State<StockAdjustmentSheet> createState() => _StockAdjustmentSheetState();
}

class _StockAdjustmentSheetState extends State<StockAdjustmentSheet> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _adjustmentType = 'Add'.tr;
  String _reasonCode = 'Damaged Goods'.tr;

  final List<String> _adjustmentTypes = ['Add'.tr, 'Remove'.tr];
  final List<String> _reasonCodes = [
    'Damaged Goods'.tr,
    'Expired Products'.tr,
    'Inventory Count Correction'.tr,
    'Other'.tr,
  ];

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentStock = (widget.product['currentStock'] as num?)?.toInt() ?? 0;

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(theme, colorScheme),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductInfo(theme, colorScheme, currentStock),
                  SizedBox(height: 3.h),
                  _buildAdjustmentTypeSelector(theme, colorScheme),
                  SizedBox(height: 3.h),
                  _buildQuantityInput(theme, colorScheme),
                  SizedBox(height: 3.h),
                  _buildReasonCodeSelector(theme, colorScheme),
                  SizedBox(height: 3.h),
                  _buildNotesInput(theme, colorScheme),
                  SizedBox(height: 3.h),
                  _buildNewStockPreview(theme, colorScheme, currentStock),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildActionButtons(theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Stock Adjustment'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(
      ThemeData theme, ColorScheme colorScheme, int currentStock) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
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
              child: widget.product['imageUrl'] != null
                  ? Image.asset(Assets.assetsImagesJustLogo)
                  : Center(
                      child: CustomIconWidget(
                        iconName: 'medication',
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                        size: 8.w,
                      ),
                    ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product['name']?.toString() ?? 'Unknown Product'.tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${'Current Stock:'.tr} $currentStock ${'units'.tr}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustmentTypeSelector(
      ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adjustment Type'.tr,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: _adjustmentTypes.map((type) {
            final isSelected = _adjustmentType == type;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: type == 'Add' ? 2.w : 0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _adjustmentType = type;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outline.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: type == 'Add' ? 'add' : 'remove',
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          type == 'Add'.tr ? 'Add Stock'.tr : 'Remove Stock'.tr,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantityInput(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity'.tr,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: _quantityController,
          keyboardType: TextInputType.number,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText:
                '${'Enter quantity to'.tr} ${_adjustmentType == 'Add'.tr ? 'add'.tr : 'remove'.tr}',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'inventory_2',
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                size: 5.w,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReasonCodeSelector(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reason Code *'.tr,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _reasonCode,
              isExpanded: true,
              items: _reasonCodes.map((reason) {
                return DropdownMenuItem<String>(
                  value: reason,
                  child: Text(
                    reason,
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _reasonCode = value ?? 'Other'.tr;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesInput(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Notes'.tr,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: _notesController,
          maxLines: 3,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Enter additional notes or comments...'.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewStockPreview(
      ThemeData theme, ColorScheme colorScheme, int currentStock) {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final newStock = _adjustmentType == 'Add'
        ? currentStock + quantity
        : currentStock - quantity;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          CustomIconWidget(
            iconName: 'arrow_forward',
            color: colorScheme.primary,
            size: 6.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'New Stock'.tr,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              Text(
                '$newStock ${'units'.tr}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: newStock < 0 ? colorScheme.error : colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, ColorScheme colorScheme) {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final isValid = quantity > 0 && _reasonCode.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'.tr),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: isValid ? _submitAdjustment : null,
              child: Text('Submit Adjustment'.tr),
            ),
          ),
        ],
      ),
    );
  }

  void _submitAdjustment() {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final adjustmentData = {
      'productId': widget.product['id'],
      'adjustmentType': _adjustmentType,
      'quantity': quantity,
      'reasonCode': _reasonCode,
      'notes': _notesController.text,
      'timestamp': DateTime.now().toIso8601String(),
      'userId': 'current_user_id', // This would come from authentication
    };

    widget.onAdjustmentSubmitted(adjustmentData);
    Navigator.pop(context);
  }
}
