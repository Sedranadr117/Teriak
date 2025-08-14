import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onClose;
  final bool hasUnsavedChanges;
  final VoidCallback onAutoSave;

  const CustomAppBarWidget({
    super.key,
    required this.onClose,
    required this.hasUnsavedChanges,
    required this.onAutoSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: const Text('إنشاء فاتورة شراء'),
      leading: IconButton(
        onPressed: onClose,
        icon: CustomIconWidget(
          iconName: 'close',
          color: theme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      actions: [
        if (hasUnsavedChanges)
          Container(
            margin: EdgeInsets.only(right: 2.w),
            child: TextButton(
              onPressed: onAutoSave,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'save',
                    color: theme.colorScheme.tertiary,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'حُفظ تلقائياً',
                    style: TextStyle(
                      color: theme.colorScheme.tertiary,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
