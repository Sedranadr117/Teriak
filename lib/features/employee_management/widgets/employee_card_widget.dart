import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:teriak/core/custom_icon_widget.dart';
import 'package:teriak/core/themes/app_theme.dart';

class EmployeeCardWidget extends StatelessWidget {
  final Map<String, dynamic> employee;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onEditPressed;
  final VoidCallback onRoleChangePressed;
  final VoidCallback onPermissionsPressed;
  final VoidCallback onDeactivatePressed;

  const EmployeeCardWidget({
    super.key,
    required this.employee,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onEditPressed,
    required this.onRoleChangePressed,
    required this.onPermissionsPressed,
    required this.onDeactivatePressed,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = employee["status"] == "Active";
    final hasAlerts = employee["hasAlerts"] == true;
    final alertCount = employee["alertCount"] as int;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Dismissible(
        key: Key('employee_${employee["id"]}'),
        background: _buildSwipeBackground(isLeft: true),
        secondaryBackground: _buildSwipeBackground(isLeft: false),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            // Swipe right - Quick actions
            _showQuickActionsBottomSheet(context);
          } else {
            // Swipe left - Deactivate
            onDeactivatePressed();
          }
        },
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            _showQuickActionsBottomSheet(context);
            return false;
          } else {
            return await _showDeactivateConfirmation(context);
          }
        },
        child: GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primaryContainer
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 2,
                    )
                  : Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                      width: 1,
                    ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Row(
                  children: [
                    // Selection Checkbox
                    if (isSelected)
                      Container(
                        margin: EdgeInsets.only(right: 3.w),
                        child: CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                      ),

                    // Profile Image
                    Stack(
                      children: [
                        Container(
                          width: 15.w,
                          height: 15.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isActive
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.outline,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              "assets/images/just_logo.png",
                              width: 15.w,
                              height: 15.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Status Indicator
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 4.w,
                            height: 4.w,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppTheme.successLight
                                  : AppTheme.lightTheme.colorScheme.outline,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.lightTheme.cardColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: 4.w),

                    // Employee Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  employee["name"] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              // Alert Badge
                              if (hasAlerts)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: AppTheme.errorLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    alertCount.toString(),
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          SizedBox(height: 0.5.h),

                          // Role Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: _getRoleColor(employee["role"] as String)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _getRoleColor(employee["role"] as String)
                                    .withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              employee["role"] as String,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color:
                                    _getRoleColor(employee["role"] as String),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          SizedBox(height: 1.h),

                          // Pharmacy and Last Login
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'location_on',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 14,
                              ),
                              SizedBox(width: 1.w),
                              Expanded(
                                child: Text(
                                  employee["pharmacy"] as String,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 0.5.h),

                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'access_time',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 14,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                'Last login: ${employee["lastLogin"]}',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Permissions Level
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: _getPermissionColor(
                                    employee["permissions"] as String)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            employee["permissions"] as String,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: _getPermissionColor(
                                  employee["permissions"] as String),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        CustomIconWidget(
                          iconName: 'chevron_right',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),

                // Internship End Date (for interns only)
                if (employee["internshipEnd"] != null) ...[
                  SizedBox(height: 2.h),
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondaryContainer
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'event',
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Internship ends: ${employee["internshipEnd"]}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isLeft}) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: isLeft
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
            : AppTheme.errorLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'edit' : 'delete',
                color: isLeft
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.errorLight,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isLeft ? 'Edit' : 'Remove',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: isLeft
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.errorLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuickActionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.bottomSheetTheme.backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Quick Actions',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            _buildQuickActionTile(
              context,
              icon: 'edit',
              title: 'Edit Profile',
              subtitle: 'Update employee information',
              onTap: () {
                Navigator.pop(context);
                onEditPressed();
              },
            ),
            _buildQuickActionTile(
              context,
              icon: 'swap_horiz',
              title: 'Change Role',
              subtitle: 'Modify employee role and responsibilities',
              onTap: () {
                Navigator.pop(context);
                onRoleChangePressed();
              },
            ),
            _buildQuickActionTile(
              context,
              icon: 'security',
              title: 'Update Permissions',
              subtitle: 'Manage access levels and permissions',
              onTap: () {
                Navigator.pop(context);
                onPermissionsPressed();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionTile(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Future<bool> _showDeactivateConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Deactivate Employee'),
            content: Text(
              'Are you sure you want to deactivate ${employee["name"]}? They will lose access to all pharmacy systems.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.errorLight,
                ),
                child: Text('Deactivate'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'pharmacist':
      case 'senior pharmacist':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'pharmacy technician':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'pharmacy assistant':
        return AppTheme.warningLight;
      case 'pharmacy intern':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  Color _getPermissionColor(String permission) {
    switch (permission.toLowerCase()) {
      case 'full access':
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
