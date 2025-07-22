import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/core/themes/app_theme.dart';
import 'package:teriak/core/widgets/custom_icon_widget.dart';
import 'package:teriak/features/employee_management/data/models/employee_model.dart';
import 'package:teriak/features/employee_management/presentation/controllers/employee_controller.dart';

class Dialogs {
  void showCredentialUpdateDialog(
    BuildContext context,
    Map<String, dynamic> employeeData,
    EmployeeController controller,
  ) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmController = TextEditingController();
    bool _obscurePassword = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, localSetState) {
          return AlertDialog(
            title: Text(
              'Reset Password',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        hintText: 'Enter new password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppTheme.textSecondaryLight,
                            size: 20,
                          ),
                          onPressed: () {
                            localSetState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                TextField(
                  controller: confirmController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm new password',
                    suffixIcon: IconButton(
                      icon: CustomIconWidget(
                        iconName:
                            _obscurePassword ? 'visibility_off' : 'visibility',
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      onPressed: () {
                        localSetState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (passwordController.text.isNotEmpty) {
                    if (passwordController.text != confirmController.text) {
                      _showErrorMessage('Passwords do not match', context);
                      return;
                    }
                    final params = EmployeeParams(
                        controller.employee.value!.firstName ?? '',
                        controller.employee.value!.lastName ?? '',
                        passwordController.text,
                        controller.employee.value!.phoneNumber,
                        controller.employee.value!.status,
                        controller.employee.value!.dateOfHire,
                        controller.employee.value!.roleId,
                        controller.employee.value!.workingHoursRequests
                            .whereType<WorkingHoursRequestParams>()
                            .toList());
                    await controller.editEmployee(
                        controller.employee.value!.id, params);
                    localSetState(() {
                      employeeData['password'] = passwordController.text;
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
      },
    );
  }

  void showSuccessMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showEditPersonalInfoDialog(
    BuildContext context,
    Map<String, dynamic> employeeData,
    EmployeeController controller,
  ) {
    final firstNameController =
        TextEditingController(text: employeeData['firstName']);
    final lastNameController =
        TextEditingController(text: employeeData['lastName']);
    final phoneController =
        TextEditingController(text: employeeData['phoneNumber']);
    DateTime? selectedDate = employeeData['dateOfHire'] != null &&
            employeeData['dateOfHire'].toString().isNotEmpty
        ? DateTime.tryParse(employeeData['dateOfHire'])
        : null;
    int selectedRoleId =
        (employeeData['roleId'] == null || employeeData['roleId'] == 0)
            ? 3
            : employeeData['roleId'];
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
                title: const Text('Edit Personal Info'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: firstNameController,
                        decoration:
                            const InputDecoration(labelText: 'First Name'),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      TextField(
                        controller: lastNameController,
                        decoration:
                            const InputDecoration(labelText: 'Last Name'),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      TextField(
                        controller: phoneController,
                        decoration:
                            const InputDecoration(labelText: 'Phone Number'),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      GestureDetector(
                        onTap: () async {
                          DateTime initialDate = selectedDate ?? DateTime.now();
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 4.w),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'calendar_today',
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                size: 20,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date of Hire',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                    SizedBox(height: 0.5.w),
                                    Text(
                                      selectedDate != null
                                          ? _formatDate(selectedDate)
                                          : 'Select date of hire',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: selectedDate != null
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant
                                                    .withOpacity(0.6),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              CustomIconWidget(
                                iconName: 'arrow_drop_down',
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 2.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'badge',
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              size: 20,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DropdownButton<int>(
                                    value: selectedRoleId,
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 3,
                                        child: Text('Pharmacist'),
                                      ),
                                      DropdownMenuItem(
                                        value: 4,
                                        child: Text('Pharmacy Intern'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          selectedRoleId = value;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                      child: const Text('Confirm'),
                      onPressed: () {
                        final params = EmployeeParams(
                          firstNameController.text,
                          lastNameController.text,
                          employeeData['password'] ?? '',
                          phoneController.text,
                          employeeData['status'],
                          selectedDate != null
                              ? "${selectedDate!.year.toString().padLeft(4, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}"
                              : (employeeData['dateOfHire'] ??
                                  DateTime.now().toString().split(' ')[0]),
                          selectedRoleId,
                          employeeData['workingHoursRequests'] ?? [],
                        );
                        controller.editEmployee(employeeData['id'], params);

                        _refreshEmployeeDataFromController(
                            controller, setState, employeeData);

                        Navigator.of(context).pop();
                      })
                ]);
          },
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
  }

  String getRoleNameById(int roleId) {
    switch (roleId) {
      case 3:
        return 'PHARMACY_EMPLOYEE';
      case 4:
        return 'PHARMACY_TRAINEE';
      default:
        return 'Unknown Role';
    }
  }

  void _refreshEmployeeDataFromController(
    EmployeeController controller,
    void Function(void Function()) setState,
    Map<String, dynamic> employeeData,
  ) {
    setState(() {
      employeeData = controller.employee.value != null
          ? {
              'id': controller.employee.value!.id,
              'firstName': controller.employee.value!.firstName,
              'lastName': controller.employee.value!.lastName,
              'phoneNumber': controller.employee.value!.phoneNumber,
              'status': controller.employee.value!.status,
              'dateOfHire': controller.employee.value!.dateOfHire,
              'roleId': controller.employee.value!.roleId,
              'roleName': controller.employee.value!.roleName,
              'workingHours': controller.employee.value!.workingHoursRequests
                  .map((e) => (e as WorkingHoursRequestModel).toJson())
                  .toList(),
            }
          : employeeData;
    });
  }

  void saveChanges(
    EmployeeController controller,
    Map<String, dynamic> employeeData,
  ) {
    final params = EmployeeParams(
      employeeData['firstName'],
      employeeData['lastName'],
      employeeData['password'] ?? '',
      employeeData['phoneNumber'],
      employeeData['status'],
      employeeData['dateOfHire'],
      employeeData['roleId'],
      employeeData['workingHoursRequests'] ?? [],
    );
    controller.editEmployee(employeeData['id'], params);
  }

  void changeStatus(
    Map<String, dynamic> employeeData,
    BuildContext context,
    EmployeeController controller,
  ) {
    int selectedRoleId =
        (employeeData['roleId'] == null || employeeData['roleId'] == 0)
            ? 3
            : employeeData['roleId'];

    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                  title: Text(
                    'Change Status',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                  content: Text(
                    'Are you sure you want to change the status of ${employeeData['firstName']} ${employeeData['lastName']}?',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                        child: const Text('Confirm'),
                        onPressed: () {
                          final newStatus = employeeData['status'] == 'ACTIVE'
                              ? 'INACTIVE'
                              : 'ACTIVE';

                          setState(() {
                            employeeData['status'] = newStatus;
                          });
                          final params = EmployeeParams(
                            employeeData['firstName'],
                            employeeData['lastName'],
                            employeeData['password'] ?? '',
                            employeeData['phoneNumber'],
                            newStatus,
                            employeeData['dateOfHire'] ??
                                DateTime.now().toString().split(' ')[0],
                            selectedRoleId,
                            employeeData['workingHoursRequests'] ?? [],
                          );
                          controller.editEmployee(employeeData['id'], params);

                          _refreshEmployeeDataFromController(
                              controller, setState, employeeData);

                          Navigator.of(context).pop();
                        })
                  ]);
            }));
  }

  Future<bool> showDeactivateDialog({
    required BuildContext context,
    required String name,
    required EmployeeController controller,
    required Map<String, dynamic> employee,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Employee'),
            content: Text(
              'Are you sure you want to delete $name? They will lose access to all pharmacy systems.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  controller.deleteEmployee(employee['id']);
                  controller.fetchAllEmployees();
                  Navigator.pop(context, true);
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.errorLight,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
