import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/core/themes/app_theme.dart';
import 'package:teriak/core/widgets/custom_icon_widget.dart';

class DaySelectionCardWidget extends StatelessWidget {
  final String day;
  final bool isSelected;
  final VoidCallback onTap;

  const DaySelectionCardWidget({
    Key? key,
    required this.day,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 28.w,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : AppTheme.borderLight,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Container(
                width: 5.w,
                height: 5.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'check',
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 16,
                ),
              )
            else
              Container(
                width: 5.w,
                height: 5.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.borderLight,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            SizedBox(height: 1.h),
            Text(
              day.substring(0, 3),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : AppTheme.textPrimaryLight,
                  ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              day,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : AppTheme.textSecondaryLight,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
