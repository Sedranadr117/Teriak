import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/themes/app_colors.dart';

class PaymentButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? processPayment;
  final String currencySymbol;
  final double totalAmount;

  const PaymentButton(
      {super.key,
      required this.isLoading,
      required this.processPayment,
      required this.currencySymbol,
      required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : processPayment,
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Processing Payment...'.tr,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.backgroundColor),
                    ),
                  ],
                )
              : Text(
                  '${'Process Payment'.tr}  ${totalAmount.toStringAsFixed(2)} $currencySymbol',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.backgroundColor),
                ),
        ),
      ),
    );
  }
}
