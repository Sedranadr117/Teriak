import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';

class TextFieldBlock extends StatefulWidget {
  final String label;
  final bool isRequired;
  final TextEditingController controller;
  //final String? errorText;
  final String hintText;
  final String iconName;
  final VoidCallback onChanged;

  const TextFieldBlock({
    super.key,
    required this.label,
    required this.isRequired,
    required this.controller,
    //required this.errorText,
    required this.hintText,
    required this.iconName,
    required this.onChanged,
  });

  @override
  State<TextFieldBlock> createState() => _TextFieldBlockState();
}

class _TextFieldBlockState extends State<TextFieldBlock> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.backgroundDark
                : AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:  isDark
                      ? AppColors.backgroundDark
                      : AppColors.backgroundLight,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
              //errorText: widget.errorText,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: context.w * 0.04,
                vertical: context.h * 0.02,
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(context.w * 0.03),
                child: CustomIconWidget(
                  iconName: widget.iconName,
                  color: isDark
                      ? AppColors.onSurfaceDark
                      : AppColors.onSurfaceLight,
                  size: 20,
                ),
              ),
            ),
            onChanged: (_) => widget.onChanged(),
          ),
        ),
      ],
    );
  }
}
