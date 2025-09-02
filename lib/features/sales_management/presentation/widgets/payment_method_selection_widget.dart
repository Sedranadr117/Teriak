import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';

class PaymentMethodSelectionWidget extends StatelessWidget {
  final String selectedMethod;
  final Function(String) onMethodSelected;

  const PaymentMethodSelectionWidget({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.payment_rounded,
                    color: Colors.blueAccent,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Method'.tr,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Choose payment option'.tr,
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
            Row(
              children: [
                Expanded(
                  child: _paymentMethod(
                      onMethodSelected: () => onMethodSelected('CASH'),
                      isSelected: selectedMethod == 'CASH'.tr,
                      title: "Cash".tr,
                      subtitle: "Pay directly with cash".tr,
                      icon: Icons.attach_money,
                      color: Colors.green),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _paymentMethod(
                      onMethodSelected: () => onMethodSelected("BANK_ACCOUNT"),
                      isSelected: selectedMethod == 'BANK_ACCOUNT'.tr,
                      title: "Credit Card".tr,
                      subtitle: "Pay with bank".tr,
                      icon: Icons.credit_card_rounded,
                      color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _paymentMethod extends StatelessWidget {
  const _paymentMethod({
    required this.onMethodSelected,
    required this.isSelected,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final VoidCallback onMethodSelected;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onMethodSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.08)
              : Theme.of(context).colorScheme.primary.withAlpha(25),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? color
                : Theme.of(context).colorScheme.primary.withAlpha(25),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected ? color : color.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 26,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? color : Colors.grey[800],
                  ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withValues(alpha: 0.6),
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 20,
              child: isSelected
                  ? Icon(
                      Icons.check_circle_rounded,
                      color: color,
                      size: 20,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
