import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/themes/app_colors.dart';

Future<bool> showDeactivateDialog(
    {required BuildContext context,
    required String name,
    required VoidCallback onTap}) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete Debts'.tr),
          content: Text(
            '${'Are you sure you want to delete Debts of'.tr} $name?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'.tr),
            ),
            TextButton(
              onPressed: () {
                onTap();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.errorLight,
              ),
              child: Text('Delete'.tr),
            ),
          ],
        ),
      ) ??
      false;
}
