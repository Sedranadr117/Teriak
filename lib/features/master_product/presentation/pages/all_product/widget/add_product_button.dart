import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/config/themes/app_theme.dart';

class AddProductButton extends StatefulWidget {
  const AddProductButton({super.key});

  @override
  State<AddProductButton> createState() => _AddProductButtonState();
}

class _AddProductButtonState extends State<AddProductButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {},
      label: Text(
        'Add Product'.tr,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.onPrimaryLight,
              fontWeight: FontWeight.w600,
            ),
      ),
      icon: const CustomIconWidget(
        iconName: 'add',
        color: AppColors.onPrimaryLight,
        size: 24,
      ),
    );
  }
}
