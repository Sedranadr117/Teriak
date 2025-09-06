import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/themes/app_colors.dart';

class PaymentButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? processPayment;
  final String currencySymbol;
  final double totalAmount;
  final bool isPaymentTypeSelected;
  final bool isCustomerSelected;
  final String paymentType;

  const PaymentButton(
      {super.key,
      required this.isLoading,
      required this.processPayment,
      required this.currencySymbol,
      required this.totalAmount,
      required this.isPaymentTypeSelected,
      required this.isCustomerSelected,
      required this.paymentType});

  bool get _canProceed {
    if (!isPaymentTypeSelected) return false;
    if (paymentType == 'CREDIT' && !isCustomerSelected) return false;
    return true;
  }

  String get _validationMessage {
    if (!isPaymentTypeSelected) return 'Please select payment type'.tr;
    if (paymentType == 'CREDIT' && !isCustomerSelected)
      return 'Please select a customer for credit payment'.tr;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        children: [
          if (!_canProceed && !isLoading)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .errorContainer
                    .withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.error,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Theme.of(context).colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _validationMessage,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (isLoading || !_canProceed) ? null : processPayment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Processing Payment...'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.backgroundColor),
                        ),
                      ],
                    )
                  : Text(
                      '${'Process Payment'.tr}  ${totalAmount.toStringAsFixed(4)} $currencySymbol',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.backgroundColor),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
