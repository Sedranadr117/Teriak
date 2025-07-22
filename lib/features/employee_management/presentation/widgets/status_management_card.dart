import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/core/themes/app_theme.dart';
import 'package:teriak/core/widgets/custom_icon_widget.dart';

class StatusManagementCard extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onStatusChanged;

  const StatusManagementCard({
    Key? key,
    required this.isActive,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'toggle_on',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Status Management',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            SizedBox(height: 4.w),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: isActive
                    ? AppTheme.successLight.withValues(alpha: 0.1)
                    : AppTheme.warningLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive
                      ? AppTheme.successLight.withValues(alpha: 0.3)
                      : AppTheme.warningLight.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppTheme.successLight
                          : AppTheme.warningLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: isActive ? 'check_circle' : 'pause_circle',
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Employee Status',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        SizedBox(height: 0.5.w),
                        Text(
                          isActive ? 'ACTIVE' : 'INACTIVE',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: isActive
                                        ? AppTheme.successLight
                                        : AppTheme.warningLight,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 1.w),
                        Text(
                          isActive
                              ? 'Employee can access systems and perform duties'
                              : 'Employee access is restricted',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isActive,
                    onChanged: onStatusChanged,
                    activeColor: AppTheme.successLight,
                    inactiveThumbColor: AppTheme.warningLight,
                    inactiveTrackColor:
                        AppTheme.warningLight.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.w),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: Theme.of(context).colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Status can be changed later from the employee Details.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
