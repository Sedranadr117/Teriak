import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:teriak/core/widgets/custom_icon_widget.dart';
import 'package:teriak/core/themes/app_theme.dart';

class RolePermissionsCardWidget extends StatelessWidget {
  final Map<String, dynamic> employeeData;
  final Function(String, bool) onPermissionChanged;

  const RolePermissionsCardWidget({
    super.key,
    required this.employeeData,
    required this.onPermissionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> permissions =
        employeeData["permissions"] as Map<String, dynamic>;
    final String role = employeeData["role"] as String;
    final bool isIntern = role.toLowerCase().contains('intern');

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
                iconName: 'security',
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Role & Permissions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Role Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: isIntern
                  ? AppTheme.warningLight.withValues(alpha: 0.1)
                  : AppTheme.successLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isIntern ? AppTheme.warningLight : AppTheme.successLight,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: isIntern ? 'school' : 'work',
                  color:
                      isIntern ? AppTheme.warningLight : AppTheme.successLight,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  role,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isIntern
                            ? AppTheme.warningLight
                            : AppTheme.successLight,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),

          // Permissions List
          Text(
            'Access Permissions',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondaryLight,
                ),
          ),
          SizedBox(height: 1.h),

          ...permissions.entries.map((entry) {
            return _buildPermissionTile(
              context,
              entry.key,
              entry.value as bool,
              isIntern,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPermissionTile(
      BuildContext context, String permission, bool isEnabled, bool isIntern) {
    final Map<String, Map<String, dynamic>> permissionDetails = {
      'inventoryAccess': {
        'title': 'Inventory Access',
        'subtitle': 'View and manage pharmacy inventory',
        'icon': 'inventory',
      },
      'salesReporting': {
        'title': 'Sales Reporting',
        'subtitle': 'Access sales data and generate reports',
        'icon': 'bar_chart',
      },
      'administrativeFunctions': {
        'title': 'Administrative Functions',
        'subtitle': 'Manage system settings and user accounts',
        'icon': 'admin_panel_settings',
      },
      'prescriptionManagement': {
        'title': 'Prescription Management',
        'subtitle': 'Process and manage prescriptions',
        'icon': 'receipt_long',
      },
      'customerService': {
        'title': 'Customer Service',
        'subtitle': 'Handle customer inquiries and support',
        'icon': 'support_agent',
      },
    };

    final details = permissionDetails[permission];
    if (details == null) return SizedBox.shrink();

    // Interns have limited permissions
    final bool canModify = !isIntern || permission != 'administrativeFunctions';

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: details['icon'] as String,
            color: isEnabled
                ? Theme.of(context).primaryColor
                : AppTheme.textDisabledLight,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details['title'] as String,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isEnabled
                            ? AppTheme.textPrimaryLight
                            : AppTheme.textDisabledLight,
                      ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  details['subtitle'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: canModify
                ? (value) => onPermissionChanged(permission, value)
                : null,
            activeColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
