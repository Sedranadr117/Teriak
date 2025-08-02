import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:sizer/sizer.dart';

import 'package:teriak/config/themes/app_icon.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onFiltersApplied,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, dynamic> _filters;

  final List<String> _suppliers = [
    'All Suppliers'.tr,
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 40.h,
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
                  _buildSupplierFilter(theme, colorScheme),
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
            'Filter Products'.tr,
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

  Widget _buildSupplierFilter(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Supplier'.tr,
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
              value: _filters['supplier'] ?? 'All Suppliers'.tr,
              isExpanded: true,
              items: _suppliers.map((supplier) {
                return DropdownMenuItem<String>(
                  value: supplier,
                  child: Text(
                    supplier,
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _filters['supplier'] = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme, ColorScheme colorScheme) {
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
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                widget.onFiltersApplied(_filters);
                Navigator.pop(context);
              },
              child: Text('Apply Filters'.tr),
            ),
          ),
        ],
      ),
    );
  }
}
