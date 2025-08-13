import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart' show CustomIconWidget;

class InvoiceHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> invoiceData;
  final Function(String) onInvoiceNumberChanged;
  final Function(String) onSupplierChanged;
  final Function(DateTime) onDateChanged;

  const InvoiceHeaderWidget({
    super.key,
    required this.invoiceData,
    required this.onInvoiceNumberChanged,
    required this.onSupplierChanged,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice Information',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 2.h),

            // Invoice Number Field
            TextFormField(
              initialValue: invoiceData['invoiceNumber'] as String? ?? '',
              decoration: const InputDecoration(
                labelText: 'Invoice Number',
                prefixIcon: Icon(Icons.receipt_long),
              ),
              onChanged: onInvoiceNumberChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Invoice number is required';
                }
                return null;
              },
            ),
            SizedBox(height: 2.h),

            // Supplier Dropdown
            DropdownButtonFormField<String>(
              value: invoiceData['supplier'] as String?,
              decoration: const InputDecoration(
                labelText: 'Supplier',
                prefixIcon: Icon(Icons.business),
              ),
              items: _getSupplierOptions().map((supplier) {
                return DropdownMenuItem<String>(
                  value: supplier,
                  child: Text(supplier),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onSupplierChanged(value);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a supplier';
                }
                return null;
              },
            ),
            SizedBox(height: 2.h),

            // Date Field
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Invoice Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _formatDate(
                      invoiceData['date'] as DateTime? ?? DateTime.now()),
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),

            // Change Indicator
            if (_hasChanges()) ...[
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .error
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .error
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'edit',
                      color: Theme.of(context).colorScheme.error,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Invoice information modified',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<String> _getSupplierOptions() {
    return [
      'Al-Dawaa Medical Supplies',
      'Gulf Pharmaceutical Co.',
      'Middle East Healthcare',
      'Arabian Medical Trading',
      'Pharma Plus Distribution',
      'Medical Care Supplies',
      'Health First Trading',
      'Wellness Pharmaceutical',
    ];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: invoiceData['date'] as DateTime? ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      onDateChanged(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  bool _hasChanges() {
    // This would compare with original data in a real implementation
    return true; // Placeholder for change detection logic
  }
}
