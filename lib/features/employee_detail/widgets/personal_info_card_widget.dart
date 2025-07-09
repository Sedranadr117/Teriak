import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:teriak/core/widgets/custom_icon_widget.dart';
import 'package:teriak/core/themes/app_theme.dart';

class PersonalInfoCardWidget extends StatelessWidget {
  final Map<String, dynamic> employeeData;
  final VoidCallback onEdit;

  const PersonalInfoCardWidget({
    super.key,
    required this.employeeData,
    required this.onEdit,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'person',
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Personal Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              IconButton(
                onPressed: onEdit,
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Information Fields
          _buildInfoRow(
              context, 'Full Name', employeeData["name"] as String, 'person'),
          SizedBox(height: 1.5.h),
          _buildInfoRow(
              context, 'Email', employeeData["email"] as String, 'email'),
          SizedBox(height: 1.5.h),
          _buildInfoRow(
              context, 'Phone', employeeData["phone"] as String, 'phone'),
          SizedBox(height: 1.5.h),
          _buildInfoRow(
              context,
              'Hire Date',
              _formatDate(employeeData["hireDate"] as String),
              'calendar_today'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, String label, String value, String iconName) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.textSecondaryLight,
          size: 18,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      final List<String> months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
