import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/core/widgets/custom_icon_widget.dart';

class EmployeeQuickActionsCard extends StatelessWidget {
  final VoidCallback? onChangeStatus;

  const EmployeeQuickActionsCard({
    Key? key,
    this.onChangeStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: _buildActionButton(
              icon: 'swap_horiz',
              label: 'Change Status',
              onPressed: onChangeStatus,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
              isFullWidth: true,
              context: context),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      {required String icon,
      required String label,
      VoidCallback? onPressed,
      required Color backgroundColor,
      required Color foregroundColor,
      bool isFullWidth = false,
      BuildContext? context}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: EdgeInsets.symmetric(
          horizontal: isFullWidth ? 4.w : 3.w,
          vertical: 3.w,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: foregroundColor,
            size: 18,
          ),
          SizedBox(width: 2.w),
          Text(
            label,
            style: Theme.of(context!).textTheme.labelLarge?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
