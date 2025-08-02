import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:sizer/sizer.dart';

<<<<<<< HEAD:lib/features/pharmacy/presentation/widgets/progress_indicator_widget.dart
=======
import 'package:teriak/config/themes/app_icon.dart';

>>>>>>> products:lib/features/pharmacy/presentation/pages/widgets/progress_indicator_widget.dart
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
    final steps = [
      'Basic Info'.tr,
      'Contact'.tr,
      'Opening Hours'.tr,
      'Manage Password'.tr,
      'Complete'.tr,
    ];
    List<Widget> buildSteps(BuildContext context, double progress) {
      final totalSteps = steps.length - 1;
      return List.generate(steps.length, (index) {
        final stepValue = index / totalSteps;
        final isCompleted = progress >= stepValue;
        final isActive =
            (progress >= (index) / totalSteps) && (progress < stepValue);
        return _buildProgressStep(
          context,
          steps[index],
          isCompleted,
          isActive: isActive,
        );
      });
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Form Progress'.tr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 0.0
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.primary,
              ),
              minHeight: 6,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: buildSteps(context, progress)),
        ],
      ),
    );
  }

  Widget _buildProgressStep(
      BuildContext context, String label, bool isCompleted,
      {bool isActive = false}) {
    Color stepColor;
    if (isCompleted) {
      stepColor = Theme.of(context).colorScheme.secondary;
    } else if (isActive) {
      stepColor = Theme.of(context).colorScheme.primary;
    } else {
      stepColor = Theme.of(context).colorScheme.outline;
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
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
