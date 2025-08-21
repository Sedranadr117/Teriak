import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/employee_management/presentation/controllers/employee_controller.dart';
import 'package:teriak/features/employee_management/presentation/widgets/account_setup_card.dart';
import 'package:teriak/features/employee_management/presentation/widgets/employment_details_card.dart';
import 'package:teriak/features/employee_management/presentation/widgets/personal_information_card.dart';
import 'package:teriak/features/employee_management/presentation/widgets/status_management_card.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeController>();
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Add Employee'.tr),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              size: 24,
            ),
          ),
        ),
        body: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(1.w),
                  child: Column(
                    children: [
                      PersonalInformationCard(
                        firstNameController: controller.firstNameController,
                        lastNameController: controller.lastNameController,
                        phoneController: controller.phoneNumberController,
                      ),
                      SizedBox(height: 4.w),
                      AccountSetupCard(
                        passwordController: controller.passwordController,
                        onStrengthChanged: (strength) {
                          setState(() {
                            controller.passwordStrength = strength;
                          });
                        },
                      ),
                      SizedBox(height: 4.w),
                      Obx(
                        () => EmploymentDetailsCard(
                          dateOfHire:
                              controller.dateOfHireController.text.isNotEmpty
                                  ? DateTime.tryParse(
                                      controller.dateOfHireController.text)
                                  : null,
                          selectedRole: controller.selectedRoleId.value == 3
                              ? 'Pharmacist'.tr
                              : controller.selectedRoleId.value == 4
                                  ? 'Pharmacy Intern'.tr
                                  : '',
                          onDateTap: () async {
                            await controller.datePicker(
                                initialDate: controller
                                        .dateOfHireController.text.isNotEmpty
                                    ? DateTime.parse(
                                        controller.dateOfHireController.text)
                                    : DateTime.now(),
                                context: context);
                            setState(() {});
                          },
                          onRoleTap: () async {
                            int? selected = await showModalBottomSheet<int>(
                              context: context,
                              builder: (context) {
                                return Obx(
                                  () => ListView(
                                    shrinkWrap: true,
                                    children: [
                                      ListTile(
                                        title: Text('Pharmacist'.tr),
                                        onTap: () => Navigator.pop(context, 3),
                                        selected:
                                            controller.selectedRoleId.value ==
                                                3,
                                      ),
                                      ListTile(
                                        title: Text('Pharmacy Intern'.tr),
                                        onTap: () => Navigator.pop(context, 4),
                                        selected:
                                            controller.selectedRoleId.value ==
                                                4,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                            if (selected != null) {
                              controller.selectedRoleId.value = selected;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 4.w),
                      Obx(
                        () => StatusManagementCard(
                          isActive: controller.isActive.value,
                          onStatusChanged: (value) {
                            controller.isActive.value = value;
                            controller.statusController.text =
                                value ? 'ACTIVE' : 'INACTIVE';
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1,
                    ),
                  ),
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: Obx(() => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  if (controller.formKey.currentState!
                                          .validate() &&
                                      controller.selectedRoleId.value != 0 &&
                                      controller.passwordStrength == 'Strong') {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      controller.addNewEmployee();
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Password is not strong enough!')),
                                    );
                                  }
                                },
                          child: controller.isLoading.value
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                )
                              : Text('Add Employee'.tr),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
