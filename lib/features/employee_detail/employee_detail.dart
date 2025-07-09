import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/core/widgets/custom_icon_widget.dart';
import 'package:teriak/core/themes/app_theme.dart';

import './widgets/activity_log_card_widget.dart';
import './widgets/credential_management_card_widget.dart';
import './widgets/employee_header_widget.dart';
import './widgets/personal_info_card_widget.dart';
import './widgets/pharmacy_assignment_card_widget.dart';
import './widgets/role_permissions_card_widget.dart';

class EmployeeDetail extends StatefulWidget {
  const EmployeeDetail({super.key});

  @override
  State<EmployeeDetail> createState() => _EmployeeDetailState();
}

class _EmployeeDetailState extends State<EmployeeDetail> {
  bool _isLoading = false;

  // Mock employee data
  final Map<String, dynamic> employeeData = {
    "id": 1,
    "name": "Sarah Johnson",
    "email": "sarah.johnson@tiryaq.com",
    "phone": "+1 (555) 123-4567",
    "role": "Pharmacy Employee",
    "status": "Active",
    "hireDate": "2023-01-15",
    "profileImage":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
    "currentPharmacy": "Downtown Medical Center",
    "pharmacyId": 1,
    "username": "sarah.johnson",
    "permissions": {
      "inventoryAccess": true,
      "salesReporting": true,
      "administrativeFunctions": false,
      "prescriptionManagement": true,
      "customerService": true
    },
    "activityLog": [
      {
        "action": "Login",
        "timestamp": "2024-01-15 09:30:00",
        "details": "Logged in from mobile app"
      },
      {
        "action": "Permission Updated",
        "timestamp": "2024-01-14 14:20:00",
        "details": "Sales reporting access granted"
      },
      {
        "action": "Password Changed",
        "timestamp": "2024-01-10 11:15:00",
        "details": "Password updated successfully"
      }
    ]
  };

  final List<Map<String, dynamic>> availablePharmacies = [
    {"id": 1, "name": "Downtown Medical Center", "address": "123 Main St"},
    {"id": 2, "name": "Westside Pharmacy", "address": "456 Oak Ave"},
    {"id": 3, "name": "Central Health Hub", "address": "789 Pine Rd"}
  ];

  void _showChangePharmacyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Change Pharmacy Assignment',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: SizedBox(
            width: 80.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: availablePharmacies.map((pharmacy) {
                final bool isSelected =
                    pharmacy["id"] == employeeData["pharmacyId"];
                return ListTile(
                  leading: CustomIconWidget(
                    iconName: isSelected
                        ? 'radio_button_checked'
                        : 'radio_button_unchecked',
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : AppTheme.textSecondaryLight,
                    size: 20,
                  ),
                  title: Text(
                    pharmacy["name"] as String,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    pharmacy["address"] as String,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  onTap: () {
                    if (!isSelected) {
                      setState(() {
                        employeeData["pharmacyId"] = pharmacy["id"];
                        employeeData["currentPharmacy"] = pharmacy["name"];
                      });
                      Navigator.of(context).pop();
                      _showSuccessMessage(
                          'Pharmacy assignment updated successfully');
                    }
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showCredentialUpdateDialog(String type) {
    final TextEditingController controller = TextEditingController();
    final TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            type == 'username' ? 'Update Username' : 'Reset Password',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                obscureText: type == 'password',
                decoration: InputDecoration(
                  labelText:
                      type == 'username' ? 'New Username' : 'New Password',
                  hintText: type == 'username'
                      ? 'Enter new username'
                      : 'Enter new password',
                ),
              ),
              if (type == 'password') ...[
                SizedBox(height: 2.h),
                TextField(
                  controller: confirmController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm new password',
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  if (type == 'password' &&
                      controller.text != confirmController.text) {
                    _showErrorMessage('Passwords do not match');
                    return;
                  }
                  setState(() {
                    if (type == 'username') {
                      employeeData["username"] = controller.text;
                    }
                  });
                  Navigator.of(context).pop();
                  _showSuccessMessage(
                      '${type == 'username' ? 'Username' : 'Password'} updated successfully');
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _saveChanges() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Save Changes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to save all changes made to this employee profile?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isLoading = true;
                });

                // Simulate API call
                Future.delayed(Duration(seconds: 2), () {
                  setState(() {
                    _isLoading = false;
                  });
                  _showSuccessMessage('Employee profile updated successfully');
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Employee Details'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _saveChanges,
            icon: CustomIconWidget(
              iconName: 'save',
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
        ],
      ),
      body: _isLoading
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
                  EmployeeHeaderWidget(
                    employeeData: employeeData,
                  ),
                  SizedBox(height: 2.h),
                  PersonalInfoCardWidget(
                    employeeData: employeeData,
                    onEdit: () {
                      _showSuccessMessage(
                          'Personal information edit functionality');
                    },
                  ),
                  SizedBox(height: 2.h),
                  PharmacyAssignmentCardWidget(
                    employeeData: employeeData,
                    onChangePharmacy: _showChangePharmacyDialog,
                  ),
                  SizedBox(height: 2.h),
                  RolePermissionsCardWidget(
                    employeeData: employeeData,
                    onPermissionChanged: (String permission, bool value) {
                      setState(() {
                        (employeeData["permissions"]
                            as Map<String, dynamic>)[permission] = value;
                      });
                    },
                  ),
                  SizedBox(height: 2.h),
                  CredentialManagementCardWidget(
                    employeeData: employeeData,
                    onUpdateUsername: () =>
                        _showCredentialUpdateDialog('username'),
                    onResetPassword: () =>
                        _showCredentialUpdateDialog('password'),
                  ),
                  SizedBox(height: 2.h),
                  ActivityLogCardWidget(
                    activityLog: (employeeData["activityLog"] as List)
                        .cast<Map<String, dynamic>>(),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveChanges,
        child: CustomIconWidget(
          iconName: 'edit',
          color: Theme.of(context).colorScheme.onPrimary,
          size: 24,
        ),
      ),
    );
  }
}
