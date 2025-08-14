import 'package:flutter/material.dart';

class CancelInvoiceDialog extends StatelessWidget {
  final VoidCallback onContinueEditing;
  final VoidCallback onCancel;

  const CancelInvoiceDialog({
    super.key,
    required this.onContinueEditing,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('إلغاء إنشاء الفاتورة؟'),
      content: const Text(
        'لديك تغييرات غير محفوظة. هل أنت متأكد من الإلغاء؟',
      ),
      actions: [
        TextButton(
          onPressed: onContinueEditing,
          child: const Text('متابعة التحرير'),
        ),
        TextButton(
          onPressed: onCancel,
          child: Text(
            'إلغاء',
            style: TextStyle(
              color: theme.colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}
