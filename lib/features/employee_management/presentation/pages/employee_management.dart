import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/widgets/custom_app_bar.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/employee_management/data/models/employee_model.dart';
import 'package:teriak/features/employee_management/presentation/controllers/employee_controller.dart';
import 'package:teriak/features/employee_management/presentation/widgets/dialogs.dart';
import 'package:teriak/features/employee_management/presentation/widgets/employee_card_widget.dart';
import 'package:teriak/features/employee_management/presentation/widgets/employee_filter_widget.dart';

class EmployeeManagement extends StatefulWidget {
  const EmployeeManagement({super.key});

  @override
  State<EmployeeManagement> createState() => _EmployeeManagementState();
}

class _EmployeeManagementState extends State<EmployeeManagement>
    with TickerProviderStateMixin {
  final controller = Get.find<EmployeeController>();
  Dialogs dialogs = Dialogs();
  @override
  void initState() {
    super.initState();
    controller.initTabController(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllEmployees();
    });
  }

  @override
  void dispose() {
    controller.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Employee Management'.tr,
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(AppPages.multiSales);
              },
              icon: CustomIconWidget(iconName: 'add')),
          IconButton(
              onPressed: () {
                Get.toNamed(AppPages.inventoryManagement);
              },
              icon: CustomIconWidget(iconName: 'abc')),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
              CacheHelper cacheHelper = CacheHelper();

              print(cacheHelper.getData(key: 'token'));
            },
            icon: CustomIconWidget(
              iconName: 'settings',
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(16.h),
          child: Column(
            children: [
              // // Search Bar
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              //   child: TextField(
              //     controller: controller.searchController,
              //     onChanged: (value) {
              //       setState(() {
              //         controller.searchQuery = value;
              //       });
              //     },
              //     decoration: InputDecoration(
              //       hintText: 'Search employees...',
              //       prefixIcon: Padding(
              //         padding: EdgeInsets.all(3.w),
              //         child: CustomIconWidget(
              //           iconName: 'search',
              //           color: Theme.of(context).colorScheme.onSurfaceVariant,
              //           size: 20,
              //         ),
              //       ),
              //       suffixIcon: controller.searchQuery.isNotEmpty
              //           ? IconButton(
              //               onPressed: () {
              //                 controller.searchController.clear();
              //                 setState(() {
              //                   controller.searchQuery = '';
              //                 });
              //               },
              //               icon: CustomIconWidget(
              //                 iconName: 'clear',
              //                 color: Theme.of(context)
              //                     .colorScheme
              //                     .onSurfaceVariant,
              //                 size: 20,
              //               ),
              //             )
              //           : null,
              //     ),
              //   ),
              // ),

              // Filter Widget
              Obx(
                () => EmployeeFilterWidget(
                  selectedFilter: controller.selectedFilter.value,
                  onFilterChanged: (filter) {
                    controller.selectedFilter.value = filter;
                  },
                ),
              ),

              // Tab Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: TabBar(
                  controller: controller.tabController,
                  onTap: (index) {
                    controller.selectedEmployees.clear();
                  },
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'people',
                            color: controller.tabController.index == 0
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                            size: 18,
                          ),
                          SizedBox(width: 2.w),
                          Text('Employees'.tr),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'school',
                            color: controller.tabController.index == 1
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                            size: 18,
                          ),
                          SizedBox(width: 2.w),
                          Text('Interns'.tr),
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
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                // Pharmacy Employees Tab
                Obx(() => _buildEmployeeList(
                    controller.getFilteredEmployeesForTab(0))),
                Obx(() => _buildEmployeeList(
                    controller.getFilteredEmployeesForTab(1))),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppPages.addEmployee),
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
        foregroundColor:
            Theme.of(context).floatingActionButtonTheme.foregroundColor,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Theme.of(context).floatingActionButtonTheme.foregroundColor!,
          size: 24,
        ),
        label: Text(
          controller.tabController.index == 0
              ? 'Add Employee'.tr
              : 'Add Intern'.tr,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color:
                    Theme.of(context).floatingActionButtonTheme.foregroundColor,
              ),
        ),
      ),
    );
  }

  Widget _buildEmployeeList(List<Map<String, dynamic>> employees) {
    if (controller.isLoading.value) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    if (employees.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: controller.refreshEmployees,
      color: Theme.of(context).colorScheme.primary,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          final isSelected =
              controller.selectedEmployees.contains(employee["id"]);

          return EmployeeCardWidget(
            employee: employee,
            isSelected: isSelected,
            onTap: () async {
              final model = EmployeeModel.fromJson(employee);
              controller.selectEmployee(model);
              await Get.toNamed(AppPages.employeeDetail, arguments: employee);
              controller.fetchAllEmployees();
              print("employee${employee}");
            },
            onDeactivatePressed: () async {
              final confirmed = await dialogs.showDeactivateDialog(
                  context: context,
                  name: employee["firstName"],
                  controller: controller,
                  employee: employee);
              if (confirmed) {
                controller.deleteEmployee(employee['id']);
                controller.fetchAllEmployees();
              }
            },
            controller: controller,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final isInternTab = controller.tabController.index == 1;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: isInternTab ? 'school' : 'people_outline',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              isInternTab ? 'No Interns Found'.tr : 'No Employees Found'.tr,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: 1.h),
          ],
        ),
      ),
    );
  }
}
