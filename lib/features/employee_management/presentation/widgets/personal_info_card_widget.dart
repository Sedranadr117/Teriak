import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:teriak/core/widgets/custom_icon_widget.dart';
import 'package:teriak/core/themes/app_theme.dart';

class PersonalInfoCardWidget extends StatefulWidget {
  final Map<String, dynamic> employeeData;
  final VoidCallback onEdit;

  const PersonalInfoCardWidget({
    super.key,
    required this.employeeData,
    required this.onEdit,
  });

  @override
  State<PersonalInfoCardWidget> createState() => _PersonalInfoCardWidgetState();
}

class _PersonalInfoCardWidgetState extends State<PersonalInfoCardWidget> {
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
                onPressed: widget.onEdit,
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          _buildInfoRow(
              context,
              'Full Name',
              "${widget.employeeData["firstName"] ?? ''} ${widget.employeeData["lastName"] ?? ''}",
              'person'),
          SizedBox(height: 1.5.h),
          _buildInfoRow(context, 'Phone',
              widget.employeeData["phoneNumber"] ?? '', 'phone'),
          SizedBox(height: 1.5.h),
          _buildInfoRow(
              context,
              'Hire Date',
              _formatDate(widget.employeeData["dateOfHire"] ?? ''),
              'calendar_today'),
          // Role Badge
          SizedBox(height: 1.5.h),

          _buildInfoRow(context, 'Role', widget.employeeData["roleName"] ?? '',
              'security'),
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
                style: label == 'Role'
                    ? Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: _getRoleColor(context, value),
                          fontWeight: FontWeight.w500,
                        )
                    : Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getRoleColor(BuildContext context, String role) {
    switch (role) {
      case 'PHARMACY_EMPLOYEE':
        return Theme.of(context).colorScheme.primary;
      case 'PHARMACY_TRAINEE':
        return Theme.of(context).colorScheme.tertiary;
      default:
        return Theme.of(context).colorScheme.error;
    }
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
