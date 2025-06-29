import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:teriak/core/custom_icon_widget.dart';
import 'package:teriak/core/themes/app_theme.dart';

class AddEmployeeBottomSheet extends StatelessWidget {
  final Function(String) onRoleSelected;

  const AddEmployeeBottomSheet({
    super.key,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final roles = [
      {
        'title': 'Pharmacist',
        'description': 'Licensed professional with full dispensing authority',
        'icon': 'local_pharmacy',
        'permissions': 'Full Access',
        'color': AppTheme.lightTheme.colorScheme.primary,
      },
      {
        'title': 'Senior Pharmacist',
        'description':
            'Experienced pharmacist with supervisory responsibilities',
        'icon': 'supervisor_account',
        'permissions': 'Full Access + Management',
        'color': AppTheme.lightTheme.colorScheme.primary,
      },
      {
        'title': 'Pharmacy Technician',
        'description': 'Certified technician supporting pharmacy operations',
        'icon': 'medical_services',
        'permissions': 'Limited Access',
        'color': AppTheme.lightTheme.colorScheme.secondary,
      },
      {
        'title': 'Pharmacy Assistant',
        'description': 'Support staff for administrative and basic tasks',
        'icon': 'support_agent',
        'permissions': 'Basic Access',
        'color': AppTheme.warningLight,
      },
      {
        'title': 'Pharmacy Intern',
        'description': 'Student gaining practical experience under supervision',
        'icon': 'school',
        'permissions': 'Intern Access',
        'color': AppTheme.lightTheme.colorScheme.tertiary,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.bottomSheetTheme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              children: [
                Text(
                  'Add New Team Member',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Select the role for the new team member',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Role Options
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: roles.length,
              itemBuilder: (context, index) {
                final role = roles[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onRoleSelected(role['title'] as String),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.shadow
                                  .withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Role Icon
                            Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                color: (role['color'] as Color)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: CustomIconWidget(
                                  iconName: role['icon'] as String,
                                  color: role['color'] as Color,
                                  size: 24,
                                ),
                              ),
                            ),

                            SizedBox(width: 4.w),

                            // Role Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    role['title'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    role['description'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 1.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 0.5.h),
                                    decoration: BoxDecoration(
                                      color: _getPermissionColor(
                                              role['permissions'] as String)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: _getPermissionColor(
                                                role['permissions'] as String)
                                            .withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      role['permissions'] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: _getPermissionColor(
                                            role['permissions'] as String),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Arrow
                            CustomIconWidget(
                              iconName: 'chevron_right',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Cancel Button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(6.w),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPermissionColor(String permission) {
    switch (permission.toLowerCase()) {
      case 'full access':
      case 'full access + management':
        return AppTheme.successLight;
      case 'limited access':
        return AppTheme.warningLight;
      case 'basic access':
      case 'intern access':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }
}
