import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';

import 'package:teriak/config/themes/app_icon.dart';

class CredentialManagementCardWidget extends StatelessWidget {
  final Map<String, dynamic> employeeData;
  final VoidCallback onUpdateUsername;
  final VoidCallback onResetPassword;

  const CredentialManagementCardWidget({
    super.key,
    required this.employeeData,
    required this.onUpdateUsername,
    required this.onResetPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Username Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CustomIconWidget(
                    iconName: 'account_circle',
                    color: AppColors.textSecondaryLight,
                    size: 18,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Username'.tr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 1.h),
          TextFormField(
            initialValue: employeeData["username"] as String,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
            ),
          ),
          SizedBox(height: 2.h),
          // Password Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CustomIconWidget(
                    iconName: 'lock',
                    color: AppColors.textSecondaryLight,
                    size: 18,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Password'.tr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 1.h),
          TextFormField(
            initialValue: '••••••••••••',
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
