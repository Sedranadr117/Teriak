import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class DebtFilterSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const DebtFilterSheet({
    super.key,
    required this.currentFilters,
    required this.onFiltersApplied,
  });

  @override
  State<DebtFilterSheet> createState() => _DebtFilterSheetState();
}

class _DebtFilterSheetState extends State<DebtFilterSheet> {
  late Map<String, dynamic> _filters;

  final List<String> _debtStatusOptions = [
    'All Debts',
    'Current',
    'Overdue',
    'Paid',
  ];

  final List<String> _sortOptions = [
    'Name',
    'Debt Amount',
    'Due Date',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
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
                  'Filter Customers',
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
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection(
                    theme,
                    colorScheme,
                    'Debt Status',
                    _buildDebtStatusFilter(theme, colorScheme),
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    theme,
                    colorScheme,
                    'Amount Range',
                    _buildAmountRangeFilter(theme, colorScheme),
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    theme,
                    colorScheme,
                    'Sort By',
                    _buildSortFilter(theme, colorScheme),
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    theme,
                    colorScheme,
                    'Options',
                    _buildOptionsFilter(theme, colorScheme),
                  ),
                ],
              ),
            ),
          ),
          Container(
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
                    onPressed: _resetFilters,
                    child: Text('Reset'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
      ThemeData theme, ColorScheme colorScheme, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        child,
      ],
    );
  }

  Widget _buildDebtStatusFilter(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: _debtStatusOptions.map((status) {
        return RadioListTile<String>(
          title: Text(status),
          value: status,
          groupValue: _filters['debtStatus'],
          onChanged: (value) {
            setState(() {
              _filters['debtStatus'] = value;
            });
          },
          dense: true,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildAmountRangeFilter(ThemeData theme, ColorScheme colorScheme) {
    final minAmount = (_filters['minAmount'] as num?)?.toDouble() ?? 0.0;
    final maxAmount = (_filters['maxAmount'] as num?)?.toDouble() ?? 5000.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Min Amount',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                controller:
                    TextEditingController(text: minAmount.toStringAsFixed(0)),
                onChanged: (value) {
                  final amount = double.tryParse(value) ?? 0.0;
                  setState(() {
                    _filters['minAmount'] = amount;
                  });
                },
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Max Amount',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                controller:
                    TextEditingController(text: maxAmount.toStringAsFixed(0)),
                onChanged: (value) {
                  final amount = double.tryParse(value) ?? 5000.0;
                  setState(() {
                    _filters['maxAmount'] = amount;
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        RangeSlider(
          values: RangeValues(minAmount, maxAmount),
          min: 0,
          max: 5000,
          divisions: 50,
          labels: RangeLabels(
            '\$${minAmount.toStringAsFixed(0)}',
            '\$${maxAmount.toStringAsFixed(0)}',
          ),
          onChanged: (values) {
            setState(() {
              _filters['minAmount'] = values.start;
              _filters['maxAmount'] = values.end;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSortFilter(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: _sortOptions.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: _filters['sortBy'],
          onChanged: (value) {
            setState(() {
              _filters['sortBy'] = value;
            });
          },
          dense: true,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildOptionsFilter(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        CheckboxListTile(
          title: Text('Show Overdue Only'),
          value: _filters['overdueOnly'] as bool? ?? false,
          onChanged: (value) {
            setState(() {
              _filters['overdueOnly'] = value ?? false;
            });
          },
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      _filters = {
        'debtStatus': 'All Debts',
        'minAmount': 0.0,
        'maxAmount': 5000.0,
        'overdueOnly': false,
        'sortBy': 'Name',
      };
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }
}
