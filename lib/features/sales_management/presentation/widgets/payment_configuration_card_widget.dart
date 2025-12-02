import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/sales_management/presentation/widgets/debt_details_section.dart';

class PaymentConfigurationCardWidget extends StatefulWidget {
  final String paymentType;
  final DateTime dueDate;
  final Function(String) onPaymentTypeChanged;
  final Function() onDateTap;
  final TextEditingController controller;

  const PaymentConfigurationCardWidget({
    super.key,
    required this.paymentType,
    required this.dueDate,
    required this.onPaymentTypeChanged,
    required this.controller,
    required this.onDateTap,
  });

  @override
  State<PaymentConfigurationCardWidget> createState() =>
      _PaymentConfigurationCardWidgetState();
}

class _PaymentConfigurationCardWidgetState
    extends State<PaymentConfigurationCardWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: InkWell(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(12),
            bottom: isExpanded ? Radius.zero : const Radius.circular(12),
          ),
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
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                        .withValues(alpha: 0.6),
                                  ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: isExpanded ? null : 0,
                child: isExpanded
                    ? Row(
                        children: [
                          Expanded(
                            child: _PaymentTypeCard(
                              title: 'Cash Payment'.tr,
                              subtitle: 'Immediate payment'.tr,
                              icon: Icons.money,
                              isSelected: widget.paymentType == 'CASH'.tr,
                              onTap: () =>
                                  widget.onPaymentTypeChanged('CASH'.tr),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _PaymentTypeCard(
                              title: 'Deferred Payment'.tr,
                              subtitle: 'Pay later terms'.tr,
                              icon: Icons.schedule,
                              isSelected: widget.paymentType == 'CREDIT'.tr,
                              onTap: () =>
                                  widget.onPaymentTypeChanged('CREDIT'.tr),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
              if (widget.paymentType == 'CREDIT') ...[
                const SizedBox(height: 16),
                DebtDetailsSection(
                  debtAmountController: widget.controller,
                  dueDate: widget.dueDate,
                  onDueDateChanged: widget.onDateTap,
                ),
              ],
            ],
          ),
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
