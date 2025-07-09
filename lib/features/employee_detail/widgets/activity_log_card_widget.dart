import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:teriak/core/widgets/custom_icon_widget.dart';
import 'package:teriak/core/themes/app_theme.dart';

class ActivityLogCardWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activityLog;

  const ActivityLogCardWidget({
    super.key,
    required this.activityLog,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'history',
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Activity Log',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Activity Items
          ...activityLog.asMap().entries.map((entry) {
            final int index = entry.key;
            final Map<String, dynamic> activity = entry.value;
            final bool isLast = index == activityLog.length - 1;

            return _buildActivityItem(context, activity, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
      BuildContext context, Map<String, dynamic> activity, bool isLast) {
    final String action = activity["action"] as String;
    final String timestamp = activity["timestamp"] as String;
    final String details = activity["details"] as String;

    // Get icon and color based on action type
    String iconName;
    Color iconColor;

    switch (action.toLowerCase()) {
      case 'login':
        iconName = 'login';
        iconColor = AppTheme.successLight;
        break;
      case 'permission updated':
        iconName = 'security';
        iconColor = Theme.of(context).primaryColor;
        break;
      case 'password changed':
        iconName = 'vpn_key';
        iconColor = AppTheme.warningLight;
        break;
      default:
        iconName = 'info';
        iconColor = AppTheme.textSecondaryLight;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: iconColor,
                  width: 2,
                ),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: iconColor,
                  size: 16,
                ),
              ),
            ),
            if (!isLast) ...[
              Container(
                width: 2,
                height: 6.h,
                color: AppTheme.borderLight,
              ),
            ],
          ],
        ),
        SizedBox(width: 3.w),

        // Activity content
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  details,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _formatTimestamp(timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textDisabledLight,
                        fontSize: 10.sp,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final DateTime dateTime = DateTime.parse(timestamp.replaceAll(' ', 'T'));
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return timestamp;
    }
  }
}
