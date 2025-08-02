import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CurrencySelectionCardWidget extends StatelessWidget {
  final String selectedCurrency;
  final Function(String) onCurrencyChanged;

  const CurrencySelectionCardWidget({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
  });

  final List<Map<String, String>> _currencies = const [
    {'code': 'USD', 'name': 'US Dollar', 'flag': '🇺🇸', 'symbol': '\$'},
    {'code': 'SYP', 'name': 'Syrian Pound', 'flag': '🇸🇾', 'symbol': 'SYP'},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.currency_exchange,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Currency Selection'.tr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text('Select your preferred transaction currency'.tr,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withValues(alpha: 0.6),
                            ))
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: selectedCurrency,
              decoration: InputDecoration(
                labelText: 'Currency'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              items: _currencies.map((currency) {
                return DropdownMenuItem<String>(
                  value: currency['symbol'],
                  child: Row(
                    children: [
                      Text(
                        currency['flag']!,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 12),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currency['symbol']!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onCurrencyChanged(newValue);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a currency'.tr;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
