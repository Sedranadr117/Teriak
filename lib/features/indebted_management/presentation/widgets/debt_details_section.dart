import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class DebtDetailsSection extends StatelessWidget {
  final TextEditingController debtAmountController;
  final DateTime dueDate;
  final String paymentTerms;
  final List<String> paymentTermsOptions;
  final TextEditingController notesController;
  final Function(DateTime) onDueDateChanged;
  final Function(String) onPaymentTermsChanged;

  const DebtDetailsSection({
    super.key,
    required this.debtAmountController,
    required this.dueDate,
    required this.paymentTerms,
    required this.paymentTermsOptions,
    required this.notesController,
    required this.onDueDateChanged,
    required this.onPaymentTermsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: debtAmountController,
          decoration: InputDecoration(
            labelText: 'Initial Debt Amount *',
            hintText: '0.00',
            prefixText: '\$',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: Icon(Icons.attach_money),
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter debt amount';
            }
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),

        SizedBox(height: 2.h),

        // Quick amount buttons
        Text(
          'Quick Amounts',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => debtAmountController.text = '50.00',
                child: Text('\$50'),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: OutlinedButton(
                onPressed: () => debtAmountController.text = '100.00',
                child: Text('\$100'),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: OutlinedButton(
                onPressed: () => debtAmountController.text = '250.00',
                child: Text('\$250'),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: OutlinedButton(
                onPressed: () => debtAmountController.text = '500.00',
                child: Text('\$500'),
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        DropdownButtonFormField<String>(
          value: paymentTerms,
          decoration: InputDecoration(
            labelText: 'Payment Terms',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: Icon(Icons.schedule),
          ),
          items: paymentTermsOptions.map((term) {
            return DropdownMenuItem(
              value: term,
              child: Text(term),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onPaymentTermsChanged(value);
            }
          },
        ),

        SizedBox(height: 2.h),

        InkWell(
          onTap: () => _selectDueDate(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.5),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                SizedBox(width: 3.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Due Date',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    Text(
                      '${dueDate.day}/${dueDate.month}/${dueDate.year}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.arrow_drop_down,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 3.h),

        TextFormField(
          controller: notesController,
          decoration: InputDecoration(
            labelText: 'Notes',
            hintText: 'Add any additional notes about this customer...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: Icon(Icons.note),
            alignLabelWithHint: true,
          ),
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null && picked != dueDate) {
      onDueDateChanged(picked);
    }
  }
}
