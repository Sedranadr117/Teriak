import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/employee_management/data/models/employee_model.dart';
import 'package:teriak/features/employee_management/presentation/controllers/employee_controller.dart';
import 'package:teriak/features/employee_management/presentation/widgets/dialogs.dart';
import 'package:teriak/features/employee_management/presentation/widgets/employee_quick_actions_card.dart';

import '../widgets/employee_header_widget.dart';
import '../widgets/personal_info_card_widget.dart';
import '../widgets/credential_management_card_widget.dart';

class EmployeeDetail extends StatefulWidget {
  const EmployeeDetail({super.key});

  @override
  State<EmployeeDetail> createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  final controller = Get.find<EmployeeController>();
  Dialogs dialogs = Dialogs();
  late Map<String, dynamic> employeeData;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      employeeData = args;

      if (controller.employee.value == null) {
        controller.employee.value = EmployeeModel.fromJson(args);
      }
    } else {
      employeeData = {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Employee Details'.tr),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      return EmployeeHeaderWidget(
                        employeeData: {
                          'id': controller.employee.value!.id,
                          'firstName': controller.employee.value!.firstName,
                          'lastName': controller.employee.value!.lastName,
                          'password': controller.employee.value!.password,
                          'phoneNumber': controller.employee.value!.phoneNumber,
                          'status': controller.employee.value!.status,
                          'dateOfHire': controller.employee.value!.dateOfHire,
                          'roleId': controller.employee.value!.roleId,
                          'roleName': controller.employee.value!.roleName.tr,
                          'workingHours': controller
                              .employee.value!.workingHoursRequests
                              .map((e) =>
                                  (e as WorkingHoursRequestModel).toJson())
                              .toList(),
                        },
                      );
                    }),
                    SizedBox(height: 2.h),
                    Obx(() {
                      return PersonalInfoCardWidget(
                        employeeData: {
                          'id': controller.employee.value!.id,
                          'firstName': controller.employee.value!.firstName,
                          'lastName': controller.employee.value!.lastName,
                          'phoneNumber': controller.employee.value!.phoneNumber,
                          'status': controller.employee.value!.status,
                          'dateOfHire': controller.employee.value!.dateOfHire,
                          'roleId': controller.employee.value!.roleId,
                          'roleName': controller.employee.value!.roleName,
                          'email': controller.employee.value!.email,
                          'workingHours': controller
                              .employee.value!.workingHoursRequests
                              .map((e) =>
                                  (e as WorkingHoursRequestModel).toJson())
                              .toList()
                        },
                        onEdit: () {
                          dialogs.showEditPersonalInfoDialog(
                            context,
                            employeeData,
                            controller,
                          );
                        },
                      );
                    }),
                    SizedBox(height: 2.h),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
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
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'schedule',
                                      color: Theme.of(context).primaryColor,
                                      size: 20,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      'Working Hours'.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.w,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Configure working schedule'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant
                                              .withValues(alpha: 0.6),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Get.toNamed(AppPages.workingHours),
                            icon: (employeeData['workingHours'] == null ||
                                    (employeeData['workingHours'] as List)
                                        .isEmpty)
                                ? CustomIconWidget(
                                    iconName: 'add',
                                    color: Theme.of(context).primaryColor,
                                    size: 20,
                                  )
                                : CustomIconWidget(
                                    iconName: 'edit',
                                    color: Theme.of(context).primaryColor,
                                    size: 20,
                                  ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    CredentialManagementCardWidget(
                      employeeData: {
                        'id': controller.employee.value!.id,
                        'firstName': controller.employee.value!.firstName,
                        'lastName': controller.employee.value!.lastName,
                        'phoneNumber': controller.employee.value!.phoneNumber,
                        'status': controller.employee.value!.status,
                        'dateOfHire': controller.employee.value!.dateOfHire,
                        'roleId': controller.employee.value!.roleId,
                        'roleName': controller.employee.value!.roleName,
                        'workingHours': controller
                            .employee.value!.workingHoursRequests
                            .map(
                                (e) => (e as WorkingHoursRequestModel).toJson())
                            .toList()
                      },
                      onResetPassword: () {},
                      // onResetPassword: () => dialogs.showCredentialUpdateDialog(
                      //     context, employeeData, controller),
                      password: employeeData['password'] ?? '',
                    ),
                    SizedBox(height: 2.h),
                    EmployeeQuickActionsCard(
                      onChangeStatus: () {
                        dialogs.changeStatus(employeeData, context, controller);
                      },
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
