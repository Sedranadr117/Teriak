import 'package:flutter/material.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';

class AddButton extends StatefulWidget {
  String label;
  void Function() onTap;
  AddButton({super.key, required this.onTap, required this.label});

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: null,
      onPressed: widget.onTap,
      label: Text(
        widget.label,
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
