import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/employee_management/presentation/controllers/employee_controller.dart';
import 'package:teriak/features/employee_management/presentation/widgets/dialogs.dart';

class EmployeeCardWidget extends StatelessWidget {
  final Map<String, dynamic> employee;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDeactivatePressed;
  final EmployeeController controller;

  const EmployeeCardWidget(
      {super.key,
      required this.employee,
      required this.isSelected,
      required this.onTap,
      required this.onDeactivatePressed,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    final isActive = employee["status"] == "ACTIVE";
    Dialogs dialogs = Dialogs();
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Dismissible(
        key: Key('employee_${employee["id"]}'),
        background: Container(),
        secondaryBackground: _buildSwipeBackground(context, isLeft: false),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            onDeactivatePressed();
          }
        },
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            return await dialogs.showDeactivateDialog(
              context: context,
              name: employee["firstName"],
              controller: controller,
              employee: employee,
            );
          }
          return null;
        },
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withValues(alpha: 0.1)
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                  : Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.2),
                      width: 1,
                    ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .shadow
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
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline,
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
                                  ? AppColors.successLight
                                  : Theme.of(context).colorScheme.outline,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).cardColor,
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
                          // Full name
                          Text(
                            '${employee["firstName"] ?? ""} ${employee["lastName"] ?? ""}'
                                .trim(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),

                          SizedBox(height: 0.5.h),

                          // Role
                          if (employee["roleName"] != null)
                            Text(
                              employee["roleName"] == 'PHARMACY_TRAINEE'
                                  ? 'Pharmacy Intern'.tr
                                  : 'Pharmacist'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: _getRoleColor(
                                        context, employee["roleName"]),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),

                          // Phone
                          if (employee["phoneNumber"] != null) ...[
                            SizedBox(height: 0.3.h),
                            Text(
                              '📞 ${employee["phoneNumber"]}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],

                          // Date of hire
                          if (employee["dateOfHire"] != null) ...[
                            SizedBox(height: 0.3.h),
                            Text(
                              '${'Hired:'.tr} ${employee["dateOfHire"]}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // // Permissions Level
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [
                    //     Container(
                    //       padding: EdgeInsets.symmetric(
                    //           horizontal: 2.w, vertical: 0.5.h),
                    //       decoration: BoxDecoration(
                    //         color: _getPermissionColor(
                    //                 context, employee["permissions"] as String)
                    //             .withValues(alpha: 0.1),
                    //         borderRadius: BorderRadius.circular(6),
                    //       ),
                    //       child: Text(
                    //         employee["permissions"] as String,
                    //         style: Theme.of(context)
                    //             .textTheme
                    //             .labelSmall
                    //             ?.copyWith(
                    //               color: _getPermissionColor(context,
                    //                   employee["permissions"] as String),
                    //               fontWeight: FontWeight.w500,
                    //             ),
                    //       ),
                    //     ),
                    //     SizedBox(height: 1.h),
                    //     CustomIconWidget(
                    //       iconName: 'chevron_right',
                    //       color: Theme.of(context).colorScheme.onSurfaceVariant,
                    //       size: 20,
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(BuildContext context, {required bool isLeft}) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: isLeft
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
            : AppColors.errorLight.withValues(alpha: 0.1),
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
                iconName: 'delete',
                color: isLeft
                    ? Theme.of(context).colorScheme.primary
                    : AppColors.errorLight,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Remove'.tr,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isLeft
                          ? Theme.of(context).colorScheme.primary
                          : AppColors.errorLight,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
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
}
