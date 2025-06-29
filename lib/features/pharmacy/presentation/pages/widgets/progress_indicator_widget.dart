import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:teriak/core/custom_icon_widget.dart';
import 'package:teriak/core/themes/app_theme.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double progress;
  final bool isDraftSaved;

  const ProgressIndicatorWidget({
    super.key,
    required this.progress,
    required this.isDraftSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Form Progress',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  if (isDraftSaved) ...[
                    CustomIconWidget(
                      iconName: 'cloud_done',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Draft Saved',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 3.w),
                  ],
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 1.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0
                    ? AppTheme.lightTheme.colorScheme.secondary
                    : AppTheme.lightTheme.colorScheme.primary,
              ),
              minHeight: 6,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressStep(
                context,
                'Basic Info',
                progress >= 0.33,
                isActive: progress >= 0.0 && progress < 0.66,
              ),
              _buildProgressStep(
                context,
                'Location',
                progress >= 0.66,
                isActive: progress >= 0.33 && progress < 1.0,
              ),
              _buildProgressStep(
                context,
                'Complete',
                progress >= 1.0,
                isActive: progress >= 1.0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(
      BuildContext context, String label, bool isCompleted,
      {bool isActive = false}) {
    Color stepColor;
    if (isCompleted) {
      stepColor = AppTheme.lightTheme.colorScheme.secondary;
    } else if (isActive) {
      stepColor = AppTheme.lightTheme.colorScheme.primary;
    } else {
      stepColor = AppTheme.lightTheme.colorScheme.outline;
    }

    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: stepColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: stepColor,
            fontWeight:
                isActive || isCompleted ? FontWeight.w600 : FontWeight.w400,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}
