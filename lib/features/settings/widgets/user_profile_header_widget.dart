import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:teriak/core/custom_icon_widget.dart';
import 'package:teriak/core/themes/app_theme.dart';

class UserProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserProfileHeaderWidget({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primaryContainer,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // TIRYAQ Logo Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.lightTheme.colorScheme.secondary,
                        AppTheme.lightTheme.colorScheme.secondaryContainer,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6.w),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'local_pharmacy',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  'TIRYAQ',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // User Profile Section
            Row(
              children: [
                // User Avatar
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.w),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      width: 3,
                    ),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.w),
                      child: Image.asset(
                        userData["avatar"] as String,
                        width: 20.w,
                        height: 20.w,
                        fit: BoxFit.cover,
                      )),
                ),

                SizedBox(width: 4.w),

                // User Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData["name"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        userData["role"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary
                              .withValues(alpha: 0.9),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        userData["email"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary
                              .withValues(alpha: 0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // User Stats
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onPrimary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    icon: 'store',
                    label: 'Pharmacies',
                    value: '${userData["pharmacyCount"]}',
                  ),
                  Container(
                    width: 1,
                    height: 6.h,
                    color: AppTheme.lightTheme.colorScheme.onPrimary
                        .withValues(alpha: 0.3),
                  ),
                  _buildStatItem(
                    icon: 'access_time',
                    label: 'Last Login',
                    value: userData["lastLogin"] as String,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 24,
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary
                  .withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
