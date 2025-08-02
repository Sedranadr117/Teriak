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

  final List<Map<String, dynamic>> _paymentMethods = const [
    {
      'name': 'Cash',
      'icon': Icons.attach_money,
      'color': Colors.green,
      'description': 'Pay directly with cash',
      'accepted': true,
    },
    {
      'name': 'Credit Card',
      'icon': Icons.credit_card_rounded,
      'color': Colors.blue,
      'description': 'Visa, MasterCard, Amex',
      'accepted': true,
    },
  ];

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
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                final method = _paymentMethods[index];
                final isSelected = selectedMethod == method['name'];
                final isAccepted = method['accepted'] as bool;

                return GestureDetector(
                  onTap: isAccepted
                      ? () => onMethodSelected(method['name'.tr])
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (method['color'] as Color).withOpacity(0.08)
                          : Theme.of(context).colorScheme.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? method['color'] as Color
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withAlpha(25),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? method['color'] as Color
                                : (method['color'] as Color).withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            method['icon'] as IconData,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                        Text(
                          method['name'.tr],
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? method['color'] as Color
                                        : Colors.grey[800],
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          method['description'],
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                                  color: method['color'] as Color,
                                  size: 20,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
