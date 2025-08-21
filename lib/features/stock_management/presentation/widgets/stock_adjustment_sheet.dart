import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/core/params/params.dart';

class StockAdjustmentSheet extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function(StockParams) onAdjustmentSubmitted;
  final bool isLoading;

  const StockAdjustmentSheet({
    super.key,
    required this.product,
    required this.onAdjustmentSubmitted,
    required this.isLoading,
  });

  @override
  State<StockAdjustmentSheet> createState() => _StockAdjustmentSheetState();
}

class _StockAdjustmentSheetState extends State<StockAdjustmentSheet> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _reasonCode = 'Damaged Goods'.tr;

  final List<String> _reasonCodes = [
    'Damaged Goods'.tr,
    'Expired Products'.tr,
    'Inventory Count Correction'.tr,
    'Other'.tr,
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentStock =
        (widget.product['totalQuantity'] as num?)?.toInt() ?? 0;

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
                  Row(
                    children: [
                      _buildQuantityInput(theme, colorScheme),
                      SizedBox(width: 3.w),
                      _buildMinStockLevelInput(theme, colorScheme)
                    ],
                  ),
                  SizedBox(height: 3.h),
                  _buildReasonCodeSelector(theme, colorScheme),
                  SizedBox(height: 3.h),
                  _buildDateExpirySelector(theme, colorScheme),
                  SizedBox(height: 3.h),
                  _buildNotesInput(theme, colorScheme),
                  SizedBox(height: 3.h),
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
              child: Center(
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
                  widget.product['productName']?.toString() ??
                      'Unknown Product'.tr,
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

  Widget _buildMinStockLevelInput(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Minimum Stock Level'.tr,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(3.w),
                child: IconButton(
                  onPressed: () {
                    if ((widget.product['minStockLevel'] ?? 0) > 0) {
                      widget.product['minStockLevel']--;
                      setState(() {});
                    }
                  },
                  icon: CustomIconWidget(
                    iconName: 'remove',
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 5.w,
                  ),
                ),
              ),
              Text((widget.product['minStockLevel'] ?? 0).toString()),
              Padding(
                padding: EdgeInsets.all(3.w),
                child: IconButton(
                  onPressed: () {
                    widget.product['minStockLevel'] =
                        (widget.product['minStockLevel'] ?? 0) + 1;
                    setState(() {});
                  },
                  icon: CustomIconWidget(
                    iconName: 'add',
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 5.w,
                  ),
                ),
              ),
            ],
          ),
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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: BoxBorder.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.all(3.w),
                  child: IconButton(
                    onPressed: () {
                      widget.product['totalQuantity']--;
                      setState(() {});
                    },
                    icon: CustomIconWidget(
                      iconName: 'remove',
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 5.w,
                    ),
                  )),
              Text(widget.product['totalQuantity'].toString()),
              Padding(
                  padding: EdgeInsets.all(3.w),
                  child: IconButton(
                    onPressed: () {
                      widget.product['totalQuantity']++;
                      setState(() {});
                    },
                    icon: CustomIconWidget(
                      iconName: 'add',
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 5.w,
                    ),
                  )),
            ],
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

  Widget _buildDateExpirySelector(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expiry Date'.tr,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: () {
            datePicker(
                context: context,
                initialDate: DateTime.parse(
                    widget.product['earliestExpiryDate'].toString()));
            setState(() {});
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(DateTime.parse(
                      widget.product['earliestExpiryDate'].toString())),
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: colorScheme.onSurface),
                ),
                CustomIconWidget(
                  iconName: 'arrow_drop_down',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> datePicker(
      {DateTime? initialDate, BuildContext? context}) async {
    DateTime? picked = await showDatePicker(
      helpText: 'Edit Expiry Date'.tr,
      cancelText: 'Cancel'.tr,
      confirmText: 'OK'.tr,
      context: context!,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      widget.product['earliestExpiryDate'] =
          picked.toIso8601String().split('T')[0];
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}-${date.year}';
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

  Widget _buildActionButtons(ThemeData theme, ColorScheme colorScheme) {
    final isValid =
        widget.product['totalQuantity'] > 0 && _reasonCode.isNotEmpty;

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
              child: widget.isLoading
                  ? SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text('Submit Adjustment'.tr),
            ),
          ),
        ],
      ),
    );
  }

  void _submitAdjustment() {
    final stockParams = StockParams(
      id: widget.product['id'],
      quantity: widget.product['totalQuantity'],
      reasonCode: _reasonCode,
      additionalNotes: _notesController.text,
      expiryDate: _formatDateForApi(widget.product['earliestExpiryDate']),
      minStockLevel: widget.product['minStockLevel'] ?? 0,
    );

    widget.onAdjustmentSubmitted(stockParams);
  }

  String _formatDateForApi(dynamic date) {
    if (date == null) return '';
    if (date is String) return date;
    if (date is DateTime) {
      return date.toIso8601String().split('T')[0];
    }
    return date.toString();
  }
}
