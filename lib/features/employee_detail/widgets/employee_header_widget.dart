import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';

class EmployeeHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> employeeData;

  const EmployeeHeaderWidget({
    super.key,
    required this.employeeData,
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
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Image
          // Container(
          //   width: 25.w,
          //   height: 25.w,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     border: Border.all(
          //       color: Theme.of(context).primaryColor,
          //       width: 3,
          //     ),
          //   ),
          //   child: ClipOval(

          //     child:
          //      CustomImageWidget(
          //       imageUrl: employeeData["profileImage"] as String,
          //       width: 25.w,
          //       height: 25.w,
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          SizedBox(height: 2.h),

          // Employee Name
          Text(
            employeeData["name"] as String,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),

          // Role Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'badge',
                  color: Theme.of(context).primaryColor,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  employeeData["role"] as String,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.h),

          // Status Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: employeeData["status"] == "Active"
                      ? AppColors.successLight
                      : AppColors.errorLight,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                employeeData["status"] as String,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: employeeData["status"] == "Active"
                          ? AppColors.successLight
                          : AppColors.errorLight,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
