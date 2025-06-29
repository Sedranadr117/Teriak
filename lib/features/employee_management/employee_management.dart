import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:teriak/core/custom_icon_widget.dart';
import 'package:teriak/core/themes/app_theme.dart';
import './widgets/add_employee_bottom_sheet.dart';
import './widgets/employee_card_widget.dart';
import './widgets/employee_filter_widget.dart';

class EmployeeManagement extends StatefulWidget {
  const EmployeeManagement({super.key});

  @override
  State<EmployeeManagement> createState() => _EmployeeManagementState();
}

class _EmployeeManagementState extends State<EmployeeManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isLoading = false;
  final List<int> _selectedEmployees = [];

  // Mock data for employees
  final List<Map<String, dynamic>> _pharmacyEmployees = [
    {
      "id": 1,
      "name": "Dr. Sarah Johnson",
      "role": "Pharmacist",
      "pharmacy": "Downtown Pharmacy",
      "status": "Active",
      "lastLogin": "2 hours ago",
      "permissions": "Full Access",
      "profileImage":
          "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&h=400&fit=crop&crop=face",
      "email": "sarah.johnson@tiryaq.com",
      "phone": "+1 (555) 123-4567",
      "hasAlerts": true,
      "alertCount": 2
    },
    {
      "id": 2,
      "name": "Michael Chen",
      "role": "Pharmacy Technician",
      "pharmacy": "Westside Pharmacy",
      "status": "Active",
      "lastLogin": "1 day ago",
      "permissions": "Limited Access",
      "profileImage":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face",
      "email": "michael.chen@tiryaq.com",
      "phone": "+1 (555) 234-5678",
      "hasAlerts": false,
      "alertCount": 0
    },
    {
      "id": 3,
      "name": "Emily Rodriguez",
      "role": "Senior Pharmacist",
      "pharmacy": "Central Pharmacy",
      "status": "Active",
      "lastLogin": "30 minutes ago",
      "permissions": "Full Access",
      "profileImage":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
      "email": "emily.rodriguez@tiryaq.com",
      "phone": "+1 (555) 345-6789",
      "hasAlerts": true,
      "alertCount": 1
    },
    {
      "id": 4,
      "name": "David Thompson",
      "role": "Pharmacy Assistant",
      "pharmacy": "Downtown Pharmacy",
      "status": "Inactive",
      "lastLogin": "1 week ago",
      "permissions": "Basic Access",
      "profileImage":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face",
      "email": "david.thompson@tiryaq.com",
      "phone": "+1 (555) 456-7890",
      "hasAlerts": false,
      "alertCount": 0
    }
  ];

  final List<Map<String, dynamic>> _interns = [
    {
      "id": 5,
      "name": "Jessica Park",
      "role": "Pharmacy Intern",
      "pharmacy": "Central Pharmacy",
      "status": "Active",
      "lastLogin": "4 hours ago",
      "permissions": "Intern Access",
      "profileImage":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop&crop=face",
      "email": "jessica.park@tiryaq.com",
      "phone": "+1 (555) 567-8901",
      "hasAlerts": false,
      "alertCount": 0,
      "internshipEnd": "June 2024"
    },
    {
      "id": 6,
      "name": "Alex Kumar",
      "role": "Pharmacy Intern",
      "pharmacy": "Westside Pharmacy",
      "status": "Active",
      "lastLogin": "1 hour ago",
      "permissions": "Intern Access",
      "profileImage":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop&crop=face",
      "email": "alex.kumar@tiryaq.com",
      "phone": "+1 (555) 678-9012",
      "hasAlerts": true,
      "alertCount": 1,
      "internshipEnd": "August 2024"
    },
    {
      "id": 7,
      "name": "Maria Santos",
      "role": "Pharmacy Intern",
      "pharmacy": "Downtown Pharmacy",
      "status": "Active",
      "lastLogin": "6 hours ago",
      "permissions": "Intern Access",
      "profileImage":
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=400&fit=crop&crop=face",
      "email": "maria.santos@tiryaq.com",
      "phone": "+1 (555) 789-0123",
      "hasAlerts": false,
      "alertCount": 0,
      "internshipEnd": "December 2024"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredEmployees() {
    List<Map<String, dynamic>> employees =
        _tabController.index == 0 ? _pharmacyEmployees : _interns;

    if (_searchQuery.isNotEmpty) {
      employees = employees.where((employee) {
        return (employee["name"] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (employee["pharmacy"] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (employee["role"] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_selectedFilter != 'All') {
      employees = employees.where((employee) {
        switch (_selectedFilter) {
          case 'Active':
            return employee["status"] == "Active";
          case 'Inactive':
            return employee["status"] == "Inactive";
          case 'With Alerts':
            return employee["hasAlerts"] == true;
          default:
            return true;
        }
      }).toList();
    }

    return employees;
  }

  Future<void> _refreshEmployees() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _showAddEmployeeBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEmployeeBottomSheet(
        onRoleSelected: (role) {
          Navigator.pop(context);
          // Navigate to add employee form with selected role
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Add \$role form would open here'),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            ),
          );
        },
      ),
    );
  }

  void _toggleEmployeeSelection(int employeeId) {
    setState(() {
      if (_selectedEmployees.contains(employeeId)) {
        _selectedEmployees.remove(employeeId);
      } else {
        _selectedEmployees.add(employeeId);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedEmployees.clear();
    });
  }

  void _showBulkActionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bulk Actions'),
        content: Text(
            'Select an action for \${_selectedEmployees.length} selected employees:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearSelection();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Role assignment would be performed here'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              );
            },
            child: Text('Change Roles'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearSelection();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Pharmacy transfer would be performed here'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              );
            },
            child: Text('Transfer Pharmacy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredEmployees = _getFilteredEmployees();

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        title: Text(
          'Employee Management',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          if (_selectedEmployees.isNotEmpty)
            IconButton(
              onPressed: _showBulkActionsDialog,
              icon: CustomIconWidget(
                iconName: 'more_vert',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            icon: CustomIconWidget(
              iconName: 'settings',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(16.h),
          child: Column(
            children: [
              // Search Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search employees...',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'search',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            icon: CustomIconWidget(
                              iconName: 'clear',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                ),
              ),

              // Filter Widget
              EmployeeFilterWidget(
                selectedFilter: _selectedFilter,
                onFilterChanged: (filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
              ),

              // Tab Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: TabBar(
                  controller: _tabController,
                  onTap: (index) {
                    setState(() {
                      _selectedEmployees.clear();
                    });
                  },
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'people',
                            color: _tabController.index == 0
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            size: 18,
                          ),
                          SizedBox(width: 2.w),
                          Text('Employees'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'school',
                            color: _tabController.index == 1
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            size: 18,
                          ),
                          SizedBox(width: 2.w),
                          Text('Interns'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Selection Header
          if (_selectedEmployees.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withValues(alpha: 0.1),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '\${_selectedEmployees.length} selected',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _clearSelection,
                    child: Text('Clear'),
                  ),
                ],
              ),
            ),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Pharmacy Employees Tab
                _buildEmployeeList(filteredEmployees),
                // Interns Tab
                _buildEmployeeList(filteredEmployees),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddEmployeeBottomSheet,
        backgroundColor:
            AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
        foregroundColor:
            AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor,
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor!,
          size: 24,
        ),
        label: Text(
          _tabController.index == 0 ? 'Add Employee' : 'Add Intern',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color:
                AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor,
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeList(List<Map<String, dynamic>> employees) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppTheme.lightTheme.colorScheme.primary,
        ),
      );
    }

    if (employees.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _refreshEmployees,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          final isSelected = _selectedEmployees.contains(employee["id"]);

          return EmployeeCardWidget(
            employee: employee,
            isSelected: isSelected,
            onTap: () {
              if (_selectedEmployees.isNotEmpty) {
                _toggleEmployeeSelection(employee["id"] as int);
              } else {
                Navigator.pushNamed(context, '/employee-detail',
                    arguments: employee);
              }
            },
            onLongPress: () {
              _toggleEmployeeSelection(employee["id"] as int);
            },
            onEditPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Edit \${employee["name"]} profile'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              );
            },
            onRoleChangePressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Change role for \${employee["name"]}'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              );
            },
            onPermissionsPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Update permissions for \${employee["name"]}'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              );
            },
            onDeactivatePressed: () {
              _showDeactivateDialog(employee);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final isInternTab = _tabController.index == 1;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: isInternTab ? 'school' : 'people_outline',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              isInternTab ? 'No Interns Found' : 'No Employees Found',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _searchQuery.isNotEmpty || _selectedFilter != 'All'
                  ? 'Try adjusting your search or filters'
                  : isInternTab
                      ? 'Start by inviting your first intern to join the team'
                      : 'Start by inviting your first employee to join the team',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 4.h),
            if (_searchQuery.isEmpty && _selectedFilter == 'All')
              ElevatedButton.icon(
                onPressed: _showAddEmployeeBottomSheet,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme
                      .lightTheme.elevatedButtonTheme.style?.foregroundColor
                      ?.resolve({}),
                  size: 20,
                ),
                label: Text(isInternTab
                    ? 'Invite First Intern'
                    : 'Invite First Employee'),
              ),
          ],
        ),
      ),
    );
  }

  void _showDeactivateDialog(Map<String, dynamic> employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Deactivate Employee'),
        content: Text(
          'Are you sure you want to deactivate \${employee["name"]}? They will lose access to all pharmacy systems.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('\${employee["name"]} has been deactivated'),
                  backgroundColor: AppTheme.warningLight,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorLight,
            ),
            child: Text('Deactivate'),
          ),
        ],
      ),
    );
  }
}
