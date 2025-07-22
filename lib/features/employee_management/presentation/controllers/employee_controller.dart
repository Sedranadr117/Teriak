import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/core/themes/app_theme.dart';
import 'package:teriak/features/employee_management/data/datasources/employee_remote_data_source.dart';
import 'package:teriak/features/employee_management/data/models/role_id_model.dart';
import 'package:teriak/features/employee_management/data/repositories/employee_repository_impl.dart';
import 'package:teriak/features/employee_management/domain/entities/employee_entity.dart';
import 'package:teriak/features/employee_management/domain/usecases/add_employee.dart';
import 'package:teriak/features/employee_management/domain/usecases/add_working_hours.dart';
import 'package:teriak/features/employee_management/domain/usecases/edit_employee.dart';
import 'package:teriak/features/employee_management/domain/usecases/get_all_roles.dart';
import 'package:teriak/features/employee_management/domain/usecases/get_all_employees.dart';
import 'package:teriak/features/employee_management/domain/usecases/delete_employee.dart';

class EmployeeController extends GetxController {
  final Rx<EmployeeEntity?> employee = Rx<EmployeeEntity?>(null);
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController dateOfHireController = TextEditingController();
  final TextEditingController shiftStartController = TextEditingController();
  final TextEditingController shiftEndController = TextEditingController();
  final TextEditingController shiftDescController = TextEditingController();
  final RxList<RoleModel> myRoles = <RoleModel>[].obs;
  final RxString currentUserType = 'intern'.obs;
  final List<String> employeeStatuses = ['Active', 'Inactive'];
  final RxBool isActive = true.obs;

  final RxInt selectedRoleId = 0.obs;
  final RxList<WorkingHoursRequestParams> workingHoursRequests =
      <WorkingHoursRequestParams>[].obs;
  late final NetworkInfoImpl networkInfo;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  late TabController tabController;
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String searchQuery = '';
  final RxString selectedFilter = 'All'.obs;
  final RxList<int> selectedEmployees = <int>[].obs;
  late final AddEmployee _addEmployee;
  late final GetAllRoles _getAllRoles;

  late final AddWorkingHoursToEmployee _addWorkingHoursToEmployee;
  late final DeleteEmployee _deleteEmployee;

  final List<String> daysOfWeek = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];

  final RxList<String> selectedDays = <String>[].obs;
  final RxList<ShiftParams> shifts = <ShiftParams>[].obs;
  final RxList<EmployeeEntity> employees = <EmployeeEntity>[].obs;
  late final GetAllEmployees _getAllEmployees;
  late final EditEmployee _editEmployee;

  late final EmployeeRemoteDataSource remoteDataSource;

  int? lastSelectedEmployeeId;

  void addOrUpdateShift(ShiftParams shiftData, {int? existingId}) {
    if (existingId != null) {
      final index = shifts.indexWhere((s) =>
          s.startTime == shiftData.startTime &&
          s.endTime == shiftData.endTime &&
          s.description == shiftData.description);
      if (index != -1) {
        shifts[index] = shiftData;
      }
    } else {
      shifts.add(shiftData);
    }
    sortShifts();
  }

  void sortShifts() {
    shifts.sort((a, b) {
      return a.startTime.compareTo(b.startTime);
    });
  }

  void deleteShift(ShiftParams shift) {
    shifts.remove(shift);
  }

  bool hasShiftConflicts() {
    for (int i = 0; i < shifts.length; i++) {
      for (int j = i + 1; j < shifts.length; j++) {
        final start1 = _parseTime(shifts[i].startTime);
        final end1 = _parseTime(shifts[i].endTime);
        final start2 = _parseTime(shifts[j].startTime);
        final end2 = _parseTime(shifts[j].endTime);

        if ((start1 < end2 && end1 > start2) ||
            (start2 < end1 && end2 > start1)) {
          return true;
        }
      }
    }
    return false;
  }

  int _parseTime(String timeString) {
    final parts = timeString.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  void saveWorkingHours(BuildContext context) {
    if (selectedDays.isEmpty) {
      Get.snackbar('Error', 'Please select at least one working day');
      return;
    }

    if (shifts.isEmpty) {
      Get.snackbar('Error', 'Please add at least one shift');
      return;
    }

    if (hasShiftConflicts()) {
      Get.snackbar('Warning', 'Shift conflicts detected. Please resolve them.');
      return;
    }

    if (employee.value == null || employee.value?.id == null) {
      Get.snackbar('Error', 'No employee selected to assign working hours.');
      return;
    }

    final workingHours = WorkingHoursRequestParams(
      selectedDays.toList(),
      shifts.toList(),
    );
    addWorkingHoursToEmployee(employee.value!.id, [workingHours]);
  }

  void clearWorkingHours() {
    selectedDays.clear();
    shifts.clear();
  }

  void selectEmployee(EmployeeEntity newEmployee) {
    if (lastSelectedEmployeeId != newEmployee.id) {
      workingHoursRequests.clear();
      clearWorkingHours();
    }
    lastSelectedEmployeeId = newEmployee.id;
    employee.value = newEmployee;
  }

  @override
  void onInit() {
    super.onInit();
    dateOfHireController.text = DateTime.now().toString().split(' ')[0];
    statusController.text = 'ACTIVE';
    if (currentUserType.value == 'pharmacist') {
      selectedRoleId.value = 1;
    } else {
      selectedRoleId.value = 2;
    }
    initializeDependencies();
    //fetchRoles();
  }

  void initializeDependencies() {
    final cacheHelper = CacheHelper();
    networkInfo = NetworkInfoImpl(InternetConnection());
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    remoteDataSource = EmployeeRemoteDataSource(api: httpConsumer);

    final repository = EmployeeRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    _addEmployee = AddEmployee(repository: repository);
    _getAllRoles = GetAllRoles(repository: repository);
    _getAllEmployees = GetAllEmployees(repository: repository);
    _addWorkingHoursToEmployee =
        AddWorkingHoursToEmployee(repository: repository);
    _editEmployee = EditEmployee(repository: repository);
    _deleteEmployee = DeleteEmployee(repository);
  }

  Future<void> fetchRoles() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _getAllRoles();
      result.fold((failure) {
        errorMessage.value = failure.errMessage;
        Get.snackbar('Error', errorMessage.value);
      }, (roleList) {
        myRoles
            .assignAll(roleList.map((e) => RoleModel.fromEntity(e)).toList());
        print('✅ Roles fetched successfully: ${myRoles.length}');
      });
    } catch (e) {
      print('❌ Unexpected error while fetching roles: $e');
      Get.snackbar('Error', 'Unexpected error occurred while fetching roles');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addNewEmployee() async {
    print('addNewEmployee called');
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    errorMessage.value = '';

    try {
      await Future.delayed(Duration(seconds: 2));

      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        errorMessage.value =
            'No internet connection. Please check your network.';
        Get.snackbar('Error', errorMessage.value);
        return;
      }

      final employeeParams = EmployeeParams(
        firstNameController.text.trim(),
        lastNameController.text.trim(),
        passwordController.text.trim(),
        phoneNumberController.text.trim(),
        statusController.text.trim().toUpperCase(),
        dateOfHireController.text.trim(),
        selectedRoleId.value,
        [],
      );

      print('🔍 Created EmployeeParams: $employeeParams');

      final result = await _addEmployee(
        firstName: employeeParams.firstName,
        lastName: employeeParams.lastName,
        password: employeeParams.password,
        phoneNumber: employeeParams.phoneNumber,
        status: employeeParams.status,
        dateOfHire: employeeParams.dateOfHire,
        roleId: employeeParams.roleId,
        workStart: [],
        daysOfWeek: [],
        shifts: [],
      );

      await result.fold((failure) {
        print('❌ Employee addition failed: ${failure.errMessage}');
        errorMessage.value = failure.errMessage;
        Get.snackbar('Error', errorMessage.value);
      }, (addedEmployee) async {
        print('✅ Employee added successfully!');
        employee.value = addedEmployee;
        Get.snackbar('Success', 'Employee added successfully!');
        Get.offNamed(AppPages.employeeManagement);
        firstNameController.clear();
        lastNameController.clear();
        passwordController.clear();
        phoneNumberController.clear();
        statusController.clear();
        dateOfHireController.clear();
        selectedRoleId.value = 0;
        workingHoursRequests.clear();
        statusController.text = 'ACTIVE';
        dateOfHireController.text = DateTime.now().toString().split(' ')[0];
      });
    } catch (e) {
      print('💥 Unexpected error: $e');
      errorMessage.value = 'An unexpected error occurred. Please try again.';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addWorkingHoursToEmployee(int employeeId,
      List<WorkingHoursRequestParams> workingHoursRequests) async {
    print('addNewEmployee cssalled');
    isLoading.value = true;
    try {
      await Future.delayed(Duration(seconds: 3));

      for (var whrs in workingHoursRequests) {
        final result = await _addWorkingHoursToEmployee(
            employeeId: employeeId, workingHours: whrs);
        result.fold(
          (failure) {
            print(
                '❌ Error adding working hours for employee $employeeId: ${failure.errMessage}');
            Get.snackbar('Error', 'Failed to add working hours for employee.');
          },
          (_) {
            Get.back();
            print('✅ Working hours added for employee $employeeId');
            Get.snackbar('Success', 'Working hours added successfully!');
          },
        );
      }
    } catch (e) {
      print('❌ Exception adding working hours for employee $employeeId: $e');
      Get.snackbar('Error', 'Failed to add working hours for employee.');
    } finally {
      isLoading.value = false;
    }
  }

  Color getPermissionColor(BuildContext context, String permission) {
    switch (permission.toLowerCase()) {
      case 'full access':
      case 'full access + management':
        return AppTheme.successLight;
      case 'limited access':
        return AppTheme.warningLight;
      case 'basic access':
      case 'intern access':
        return Theme.of(context).colorScheme.secondary;
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }

  Future<void> openWorkingHoursScreen(BuildContext context) async {
    final result = await Get.toNamed(AppPages.workingHours);
    if (result != null && result is List<WorkingHoursRequestParams>) {
      workingHoursRequests.assignAll(result);
    }
  }

  List<Map<String, dynamic>> getFilteredEmployeesForTab(int tabIndex) {
    String role = tabIndex == 0 ? 'PHARMACY_EMPLOYEE' : 'PHARMACY_TRAINEE';
    return employees
        .where((e) => e.roleName == role)
        .where((e) {
          if (selectedFilter.value == 'All') return true;
          if (selectedFilter.value == 'Active') return e.status == 'ACTIVE';
          if (selectedFilter.value == 'Inactive') return e.status == 'INACTIVE';

          return true;
        })
        .map((e) => {
              "id": e.id,
              "firstName": e.firstName,
              "lastName": e.lastName,
              "status": e.status,
              "dateOfHire": e.dateOfHire,
              "roleName": e.roleName,
              "phoneNumber": e.phoneNumber,
              "workingHours": e.workingHoursRequests,
            })
        .toList();
  }

  Future<void> refreshEmployees() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;
  }

  void initTabController(TickerProvider ticker) {
    tabController = TabController(length: 2, vsync: ticker);
  }

  void toggleDaySelection(String day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day);
    } else {
      selectedDays.add(day);
    }
  }

  void saveSchedule(BuildContext context) async {
    if (selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one working day'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (shifts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add at least one shift'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (hasShiftConflicts()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please resolve shift conflicts before saving'),
          backgroundColor: AppTheme.warningLight,
        ),
      );
      return;
    }

    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Working hours saved successfully'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  Future<void> fetchAllEmployees() async {
    print('fetchAllEmployees called');
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _getAllEmployees();
      result.fold((failure) {
        print('❌ Error fetching employees: ${failure.errMessage}');
        errorMessage.value = failure.errMessage;
        Get.snackbar('Error', errorMessage.value);
      }, (employeeList) {
        print('✅ Employees fetched: ${employeeList.length}');
        for (var emp in employeeList) {
          print('Employee: ${emp.firstName} ${emp.lastName}');
        }
        employees.assignAll(employeeList);
      });
    } catch (e) {
      print('💥 Unexpected error while fetching employees: $e');
      errorMessage.value = 'Unexpected error occurred while fetching employees';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editEmployee(int employeeId, EmployeeParams params) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _editEmployee(
        id: employeeId,
        firstName: params.firstName,
        lastName: params.lastName,
        password: params.password,
        phoneNumber: params.phoneNumber,
        status: params.status,
        dateOfHire: params.dateOfHire,
        roleId: params.roleId,
        workStart: [],
        daysOfWeek: [],
        shifts: [],
      );
      result.fold(
        (failure) {
          errorMessage.value = failure.errMessage;
          Get.snackbar('Error', failure.errMessage);
        },
        (updatedEmployee) {
          employee.value = updatedEmployee;
          Future.delayed(Duration(milliseconds: 100), () {
            Get.snackbar('Success', 'Employee updated successfully!');
          });
          // Get.back();
        },
      );
    } catch (e) {
      print('❌ Error editing employee: $e');
      errorMessage.value = 'Failed to update employee.';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteEmployee(int id) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _deleteEmployee(id);
      result.fold(
        (failure) {
          errorMessage.value = failure.errMessage;
          Get.snackbar('Error', failure.errMessage);
        },
        (_) {
          Get.snackbar('Success', 'Employee deleted successfully!');
          fetchAllEmployees();
        },
      );
    } catch (e) {
      print('❌ Error deleting employee: $e');
      errorMessage.value = 'Failed to delete employee.';
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    statusController.dispose();
    dateOfHireController.dispose();
    shiftStartController.dispose();
    shiftEndController.dispose();
    shiftDescController.dispose();
    super.onClose();
  }
}
