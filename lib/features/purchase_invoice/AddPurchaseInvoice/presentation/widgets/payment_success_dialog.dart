import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teriak/config/themes/app_icon.dart';

class PaymentSuccessDialog extends StatelessWidget {
  final String invoiceNumber;
  final String supplier;
  final double totalAmount;
  final List<Map<String, dynamic>> products;
  final VoidCallback onGoHome;
  

  const PaymentSuccessDialog({
    super.key,
    required this.invoiceNumber,
    required this.supplier,
    required this.totalAmount,
    required this.products,
    required this.onGoHome,
 
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      icon: CustomIconWidget(
        iconName: 'check_circle',
        color: theme.colorScheme.tertiary,
        size: 48,
      ),
      title: const Text(
        'تم إنشاء الفاتورة بنجاح!',
        style: TextStyle(fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'رقم الفاتورة: $invoiceNumber',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'المبلغ الإجمالي: \$${NumberFormat('#,##0.00').format(totalAmount)}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onGoHome,
          child: const Text('العودة للرئيسية'),
        ),
     
      ],
    );
  }
}
