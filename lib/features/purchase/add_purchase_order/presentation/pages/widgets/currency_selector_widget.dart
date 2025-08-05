import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';



enum Currency { syp, usd }

class CurrencySelectorWidget extends StatelessWidget {
  final Currency selectedCurrency;
  final Function(Currency) onCurrencyChanged;

  const CurrencySelectorWidget({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Currency',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            SizedBox(height: 2.h),
            _buildCurrencySelector(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencySelector(BuildContext context,) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildCurrencyOption(
              context: context,
              currency: Currency.syp,
              label: 'Syrian Pound',
              symbol: 'ليرة',
              isSelected: selectedCurrency == Currency.syp,
            ),
          ),
          Container(
            width: 1,
            height: 6.h,
            color: Theme.of(context).colorScheme.outline,
          ),
          Expanded(
            child: _buildCurrencyOption(
              context: context,
              currency: Currency.usd,
              label: 'US Dollar',
              symbol: '\$',
              isSelected: selectedCurrency == Currency.usd,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyOption({
    required BuildContext context,
    required Currency currency,
    required String label,
    required String symbol,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => onCurrencyChanged(currency),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  symbol,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
