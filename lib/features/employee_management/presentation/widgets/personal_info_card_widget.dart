import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';

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
                    'Personal Information'.tr,
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
              'Full Name'.tr,
              "${widget.employeeData["firstName"] ?? ''} ${widget.employeeData["lastName"] ?? ''}",
              'person'),
          SizedBox(height: 1.5.h),
          _buildInfoRow(context, 'Phone'.tr,
              widget.employeeData["phoneNumber"] ?? '', 'phone'),
          SizedBox(height: 1.5.h),
          _buildInfoRow(
              context,
              'Hire Date'.tr,
              _formatDate(widget.employeeData["dateOfHire"] ?? ''),
              'calendar_today'),
          // Role Badge
          SizedBox(height: 1.5.h),

          _buildInfoRow(
              context,
              'Role'.tr,
              widget.employeeData["roleName"] == 'PHARMACY_TRAINEE'
                  ? 'Pharmacy Intern'.tr
                  : 'Pharmacist'.tr,
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
          color: AppColors.textSecondaryLight,
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
                      color: AppColors.textSecondaryLight,
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
        'Jan'.tr,
        'Feb'.tr,
        'Mar'.tr,
        'Apr'.tr,
        'May'.tr,
        'Jun'.tr,
        'Jul'.tr,
        'Aug'.tr,
        'Sep'.tr,
        'Oct'.tr,
        'Nov'.tr,
        'Dec'.tr
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
