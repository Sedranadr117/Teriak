import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';

class DropDownBlock extends StatefulWidget {
  final String label;
  final String iconName;
  final bool isRequired;
  final String? value;
  final VoidCallback onTap;

  const DropDownBlock({
    super.key,
    required this.label,
    required this.iconName,
    required this.isRequired,
    required this.value,
    required this.onTap,
  });

  @override
  State<DropDownBlock> createState() => _DropDownBlockState();
}

class _DropDownBlockState extends State<DropDownBlock> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor =
        widget.value != null ? theme.colorScheme.onSurface : Colors.grey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            if (widget.isRequired)
              Text(
                ' *',
                style: TextStyle(color: AppColors.errorLight, fontSize: 14.sp),
              ),
          ],
        ),
        SizedBox(height: context.h * 0.01),
        InkWell(
          onTap: widget.onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: context.w * 0.04,
              vertical: context.h * 0.02,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: widget.iconName,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                SizedBox(width: context.w * 0.03),
                Expanded(
                  child: Text(
                    widget.value ?? widget.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textColor,
                    ),
                    softWrap: true,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
