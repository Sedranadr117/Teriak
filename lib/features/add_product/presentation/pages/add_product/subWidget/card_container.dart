import 'package:flutter/material.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';

// ignore: must_be_immutable
class CustomContainer extends StatefulWidget {
  String iconName;
  String labelName;
  List<Widget> widgets;
  CustomContainer(
      {super.key,
      required this.iconName,
      required this.labelName,
      required this.widgets});

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.w * 0.04,
        vertical: context.h * 0.01,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
            width: 4.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.shadowDark.withValues(alpha: 0.05)
                : AppColors.shadowLight.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(context.w * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: widget.iconName,
                  color:
                      isDark ? AppColors.primaryDark : AppColors.primaryLight,
                  size: 20,
                ),
                SizedBox(width: context.w * 0.02),
                Text(
                  widget.labelName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.primaryDark
                            : AppColors.primaryLight,
                      ),
                ),
              ],
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.widgets)
          ],
        ),
      ),
    );
  }
}
