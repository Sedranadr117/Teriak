import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/presentation/pages/widgets/unified_card.dart';

class CurrencySelectionCard extends StatelessWidget {
  final String selectedCurrency;
  final Function(String) onCurrencyChanged;
  final List<String> availableCurrencies;

  const CurrencySelectionCard({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
    required this.availableCurrencies,
  });

  @override
  Widget build(BuildContext context) {
    return UnifiedCard(
      iconName: 'monetization_on',
      title: 'Select Currency'.tr,
      children: [
        _buildCurrencyOptions(),
      ],
    );
  }

  Widget _buildCurrencyOptions() {
    return Row(
      children: availableCurrencies.map((currency) {
        final isSelected = currency == selectedCurrency;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              print("select$selectedCurrency");
              print("curr$currency");
              onCurrencyChanged(currency);
            },
            child: Container(
              margin: EdgeInsets.only(
                right: currency == availableCurrencies.last ? 0 : 1.w,
              ),
              padding: EdgeInsets.symmetric(
                vertical: 1.2.h,
                horizontal: 2.w,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryLight : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryLight
                      : AppColors.borderLight,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    _getCurrencyName(currency),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.onPrimaryLight
                          : AppColors.primaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 0.4.h),
                  Text(
                    _getCurrencySymbol(currency),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppColors.onPrimaryLight
                          : AppColors.primaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getCurrencyName(String currency) {
    switch (currency) {
      case 'SYP':
        return 'Currency SYP'.tr;
      case 'USD':
        return 'Currency USD'.tr;
      default:
        return currency;
    }
  }

  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'SYP':
        return 'SYP'.tr;
      case 'USD':
        return 'USD'.tr;
      default:
        return currency;
    }
  }
}
