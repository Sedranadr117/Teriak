import 'package:flutter/material.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'vpn_key',
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Credential Management',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Username Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.borderLight,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'account_circle',
                          color: AppColors.textSecondaryLight,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Username',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondaryLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: onUpdateUsername,
                      child: Text('Change'),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  employeeData["username"] as String,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),

          // Password Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.borderLight,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'lock',
                          color: AppColors.textSecondaryLight,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Password',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondaryLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: onResetPassword,
                      child: Text('Reset'),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  '••••••••••••',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),

          // Security Notice
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppColors.warningLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.warningLight.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppColors.warningLight,
                  size: 18,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Credential changes require administrator approval and will be logged for security purposes.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.warningLight,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
