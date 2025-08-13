// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:sizer/sizer.dart';

import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';

class ShiftCardWidget extends StatelessWidget {
  final Map<String, dynamic> shift;
  final bool hasConflict;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ShiftCardWidget({
    Key? key,
    required this.shift,
    required this.hasConflict,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  String _formatTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];

    if (hour == 0) {
      return '12:$minute AM';
    } else if (hour < 12) {
      return '$hour:$minute AM';
    } else if (hour == 12) {
      return '12:$minute PM';
    } else {
      return '${hour - 12}:$minute PM';
    }
  }

  bool _isOvernightShift() {
    return shift['isOvernight'] == true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showContextMenu(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: hasConflict
              ? Border.all(
                  color: AppColors.warningLight,
                  width: 2,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: hasConflict
                  ? AppColors.warningLight.withValues(alpha: 0.2)
                  : AppColors.shadowLight,
              blurRadius: hasConflict ? 8 : 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    (shift['day'] as List)
                        .map((day) =>
                            day.toString().substring(0, 3).toUpperCase())
                        .join(', '),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),

                Spacer(),

                if (hasConflict)
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppColors.warningLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'warning',
                          color: AppColors.warningLight,
                          size: 12,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Conflict'.tr,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.warningLight,
                                  ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(width: 2.w),

                // More Options
                GestureDetector(
                  onTap: () => _showContextMenu(context),
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    child: CustomIconWidget(
                      iconName: 'more_vert',
                      color: AppColors.textSecondaryLight,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'access_time',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  '${_formatTime(shift['startTime'])} - ${_formatTime(shift['endTime'])}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (_isOvernightShift()) ...[
                  SizedBox(width: 2.w),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Overnight'.tr,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ),
                ],
              ],
            ),
            if (shift['description'] != null &&
                shift['description'].toString().isNotEmpty) ...[
              SizedBox(height: 1.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomIconWidget(
                    iconName: 'description',
                    color: AppColors.textSecondaryLight,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      shift['description'].toString(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            color: AppColors.textSecondaryLight,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                margin: EdgeInsets.only(top: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'Shift Options'.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete',
                  color: Theme.of(context).colorScheme.error,
                  size: 24,
                ),
                title: Text(
                  'Delete Shift'.tr,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 14.sp,
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
