import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:teriak/core/widgets/custom_icon_widget.dart';
import 'package:teriak/core/themes/app_theme.dart';

class CredentialManagementCardWidget extends StatefulWidget {
  final Map<String, dynamic> employeeData;
  final VoidCallback onResetPassword;
  final String password;

  const CredentialManagementCardWidget({
    super.key,
    required this.employeeData,
    required this.onResetPassword,
    required this.password,
  });

  @override
  State<CredentialManagementCardWidget> createState() =>
      _CredentialManagementCardWidgetState();
}

class _CredentialManagementCardWidgetState
    extends State<CredentialManagementCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
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

          // Password Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.borderLight,
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
                        const CustomIconWidget(
                          iconName: 'lock',
                          color: AppTheme.textSecondaryLight,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Password',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textSecondaryLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: widget.onResetPassword,
                          child: const Text('Reset'),
                        ),
                      ],
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
        ],
      ),
    );
  }
}
