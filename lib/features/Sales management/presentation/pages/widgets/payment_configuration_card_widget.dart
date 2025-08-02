import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class PaymentConfigurationCardWidget extends StatefulWidget {
  final String paymentType;
  final DateTime? dueDate;
  final Function(String) onPaymentTypeChanged;
  final Function(DateTime?) onDueDateChanged;

  const PaymentConfigurationCardWidget({
    super.key,
    required this.paymentType,
    required this.dueDate,
    required this.onPaymentTypeChanged,
    required this.onDueDateChanged,
  });

  @override
  State<PaymentConfigurationCardWidget> createState() =>
      _PaymentConfigurationCardWidgetState();
}

class _PaymentConfigurationCardWidgetState
    extends State<PaymentConfigurationCardWidget> {
  final List<String> _paymentTerms = [
    'Net 15'.tr,
    'Net 30'.tr,
    'Net 60'.tr,
    'Net 90'.tr,
    'Custom'.tr
  ];
  String _selectedTerm = 'Net 30'.tr;

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          widget.dueDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Select Due Date'.tr,
      cancelText: 'Cancel'.tr,
      confirmText: 'Select'.tr,
    );

    if (picked != null) {
      widget.onDueDateChanged(picked);
      _updatePaymentTerm(picked);
    }
  }

  void _updatePaymentTerm(DateTime dueDate) {
    final daysDifference = dueDate.difference(DateTime.now()).inDays;
    if (daysDifference <= 15) {
      _selectedTerm = 'Net 15';
    } else if (daysDifference <= 30) {
      _selectedTerm = 'Net 30';
    } else if (daysDifference <= 60) {
      _selectedTerm = 'Net 60';
    } else if (daysDifference <= 90) {
      _selectedTerm = 'Net 90';
    } else {
      _selectedTerm = 'Custom'.tr;
    }
    setState(() {});
  }

  void _onPaymentTermChanged(String term) {
    setState(() {
      _selectedTerm = term;
    });

    DateTime newDueDate;
    switch (term.tr) {
      case 'Net 15':
        newDueDate = DateTime.now().add(const Duration(days: 15));
        break;
      case 'Net 30':
        newDueDate = DateTime.now().add(const Duration(days: 30));
        break;
      case 'Net 60':
        newDueDate = DateTime.now().add(const Duration(days: 60));
        break;
      case 'Net 90':
        newDueDate = DateTime.now().add(const Duration(days: 90));
        break;
      default:
        return;
    }
    widget.onDueDateChanged(newDueDate);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.payment,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Configuration'.tr,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Configure payment type and terms'.tr,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withValues(alpha: 0.6),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Payment Type Selection
            Row(
              children: [
                Expanded(
                  child: _PaymentTypeCard(
                    title: 'Cash Payment'.tr,
                    subtitle: 'Immediate payment'.tr,
                    icon: Icons.money,
                    isSelected: widget.paymentType == 'Cash'.tr,
                    onTap: () => widget.onPaymentTypeChanged('Cash'.tr),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PaymentTypeCard(
                    title: 'Deferred Payment'.tr,
                    subtitle: 'Pay later terms'.tr,
                    icon: Icons.schedule,
                    isSelected: widget.paymentType == 'Deferred Payment'.tr,
                    onTap: () =>
                        widget.onPaymentTypeChanged('Deferred Payment'.tr),
                  ),
                ),
              ],
            ),

            // Cash Payment Confirmation
            if (widget.paymentType == 'Cash') ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green[700],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Immediate Payment Selected'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green[700],
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Payment will be processed immediately upon completion'
                                .tr,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.green[700],
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Deferred Payment Configuration
            if (widget.paymentType == 'Deferred Payment') ...[
              const SizedBox(height: 16),

              // Payment Terms
              DropdownButtonFormField<String>(
                value: _selectedTerm,
                decoration: InputDecoration(
                  labelText: 'Payment Terms'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                items: _paymentTerms.map((term) {
                  return DropdownMenuItem(
                    value: term,
                    child: Text(
                      term,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _onPaymentTermChanged(newValue);
                  }
                },
              ),

              const SizedBox(height: 16),

              // Due Date Selection
              InkWell(
                onTap: _selectDueDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.date_range, color: Colors.grey),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Due Date'.tr,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.dueDate != null
                                ? '${widget.dueDate!.day}/${widget.dueDate!.month}/${widget.dueDate!.year}'
                                : 'Select due date'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: widget.dueDate != null
                                      ? Colors.black
                                      : Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}

class _PaymentTypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentTypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withAlpha(26)
              : Theme.of(context).colorScheme.primary.withAlpha(26),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[400],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[700],
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withValues(alpha: 0.6),
                  ),
            )
          ],
        ),
      ),
    );
  }
}
