import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
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
import 'package:teriak/features/employee_management/domain/usecases/get_employee_by_id.dart';

class EmployeeController extends GetxController {
  Rx<EmployeeEntity?> employee = Rx<EmployeeEntity?>(null);
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController dateOfHireController = TextEditingController();
  final TextEditingController shiftStartController = TextEditingController();
  final TextEditingController shiftEndController = TextEditingController();
  final TextEditingController shiftDescController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final RxList<RoleModel> myRoles = <RoleModel>[].obs;
  final RxString currentUserType = 'intern'.obs;
  final List<String> employeeStatuses = ['Active', 'Inactive'];
  final RxBool isActive = true.obs;
  String passwordStrength = '';

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
  late final RxString selectedFilter;
  final RxList<int> selectedEmployees = <int>[].obs;
  late final AddEmployee _addEmployee;
  late final GetAllRoles _getAllRoles;
  late final GetEmployeeById _getEmployeeById;

  late final AddWorkingHoursToEmployee _addWorkingHoursToEmployee;
  late final DeleteEmployee _deleteEmployee;
  RxList<String> selectedDays = <String>[].obs;

  final List<String> daysOfWeek = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];

  final RxList<ShiftParams> shifts = <ShiftParams>[].obs;
  final RxList<EmployeeEntity> employees = <EmployeeEntity>[].obs;
  late final GetAllEmployees _getAllEmployees;
  late final EditEmployee _editEmployee;

  late final EmployeeRemoteDataSource remoteDataSource;

  int? lastSelectedEmployeeId;

  void addOrUpdateShiftForDays(ShiftParams shiftData,
      {List<String>? selectedDays, int? existingId}) {
    if (selectedDays == null || selectedDays.isEmpty) return;

    final existingRequestIndex = workingHoursRequests.indexWhere((req) =>
        Set.from(req.daysOfWeek).containsAll(selectedDays) &&
        Set.from(selectedDays).containsAll(req.daysOfWeek));

    if (existingRequestIndex != -1) {
      final request = workingHoursRequests[existingRequestIndex];
      if (existingId != null) {
        request.shifts[existingId] = shiftData;
      } else {
        request.shifts.add(shiftData);
      }
    } else {
      workingHoursRequests.add(
        WorkingHoursRequestParams(
          daysOfWeek: selectedDays,
          shifts: [shiftData],
        ),
      );
    }

    sortShifts();
  }

  void addShift(ShiftParams shift, {List<String>? selectedDays}) {
    final request = WorkingHoursRequestParams(
      daysOfWeek: selectedDays ?? [],
      shifts: [shift],
    );

    workingHoursRequests.add(request); // RxList
    shifts.add(shift); // RxList
  }

  void buildWorkingHoursRequests() {
    workingHoursRequests.clear();
    workingHoursRequests.add(WorkingHoursRequestParams(
        daysOfWeek: daysOfWeek, shifts: shifts.toList()));
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
    for (int i = 0; i < workingHoursRequests.length; i++) {
      final req1 = workingHoursRequests[i];
      for (int j = 0; j < req1.shifts.length; j++) {
        final shift1 = req1.shifts[j];
        for (int k = i; k < workingHoursRequests.length; k++) {
          final req2 = workingHoursRequests[k];
          for (int l = 0; l < req2.shifts.length; l++) {
            final shift2 = req2.shifts[l];

            final commonDays =
                req1.daysOfWeek.toSet().intersection(req2.daysOfWeek.toSet());
            if (commonDays.isEmpty) continue;

            final start1 = _parseTime(shift1.startTime);
            final end1 = _parseTime(shift1.endTime);
            final start2 = _parseTime(shift2.startTime);
            final end2 = _parseTime(shift2.endTime);

            if ((start1 < end2 && end1 > start2) && !(i == k && j == l)) {
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  int _parseTime(String timeString) {
    final parts = timeString.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  void saveWorkingHours() {
    if (workingHoursRequests.isEmpty) {
      Get.snackbar('Error'.tr, 'Please add at least one shift'.tr);
      return;
    }

    if (hasShiftConflicts()) {
      Get.snackbar(
          'Error'.tr, 'Please resolve shift conflicts before saving'.tr);
      return;
    }

    if (employee.value == null || employee.value?.id == null) {
      Get.snackbar(
          'Error'.tr, 'No employee selected to assign working hours.'.tr);
      return;
    }

    addWorkingHoursToEmployee(
      employee.value!.id,
      workingHoursRequests.toList(),
    );
  }

  void clearWorkingHours() {
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

  Future<void> datePicker(
      {DateTime? initialDate, BuildContext? context}) async {
    DateTime? picked = await showDatePicker(
      helpText: 'Select date of hire'.tr,
      cancelText: 'Cancel'.tr,
      confirmText: 'OK'.tr,
      context: context!,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      dateOfHireController.text = picked.toIso8601String().split('T')[0];
    }
  }

  @override
  void onInit() {
    super.onInit();
    dateOfHireController.text = DateTime.now().toString().split(' ')[0];
    statusController.text = 'ACTIVE';
    selectedFilter = 'all'.obs;

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
    networkInfo = NetworkInfoImpl();
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
    _getEmployeeById = GetEmployeeById(repository: repository);
  }

  Future<void> fetchRoles() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _getAllRoles();
      result.fold((failure) {
        if (failure.statusCode == 500) {
          errorMessage.value =
              'An unexpected error occurred. Please try again.'.tr;
          Get.snackbar('Error'.tr, errorMessage.value);
        } else {
          errorMessage.value = failure.errMessage;
          Get.snackbar('Errors'.tr, errorMessage.value);
        }
      }, (roleList) {
        myRoles
            .assignAll(roleList.map((e) => RoleModel.fromEntity(e)).toList());
        print('✅ Roles fetched successfully: ${myRoles.length}');
      });
    } catch (e) {
      print('❌ Unexpected error while fetching roles: $e');
      Get.snackbar(
          'Error'.tr, 'Unexpected error occurred while fetching roles'.tr);
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
            'No internet connection. Please check your network.'.tr;
        Get.snackbar('Error'.tr, errorMessage.value);
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
        if (failure.statusCode == 500) {
          errorMessage.value =
              'An unexpected error occurred. Please try again.'.tr;
          Get.snackbar('Error'.tr, errorMessage.value);
        } else {
          errorMessage.value = failure.errMessage;
          Get.snackbar('Errors'.tr, errorMessage.value);
        }
      }, (addedEmployee) async {
        print('✅ Employee added successfully!');
        employee.value = addedEmployee;
        Get.snackbar('Success'.tr, 'Employee added successfully!'.tr);
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
      errorMessage.value = 'An unexpected error occurred. Please try again.'.tr;
      Get.snackbar('Error'.tr, errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  void addWorkingHoursForDays(List<String> days, List<ShiftParams> shifts) {
    workingHoursRequests.add(
      WorkingHoursRequestParams(
        daysOfWeek: [], shifts: shifts, // List<String>
      ),
    );
  }

  Future<void> addWorkingHoursToEmployee(int employeeId,
      List<WorkingHoursRequestParams> workingHoursRequests) async {
    print('✅ Working hours start');

    isLoading.value = true;
    try {
      final result = await _addWorkingHoursToEmployee(
        employeeId: employeeId,
        workingHours: workingHoursRequests,
      );
      result.fold(
        (failure) {
          if (failure.statusCode == 500) {
            errorMessage.value = 'Failed to add working hours.'.tr;
            Get.snackbar('Error'.tr, errorMessage.value);
          } else {
            errorMessage.value = 'Failed to add working hours.'.tr;

            Get.snackbar('Errors'.tr, errorMessage.value);
          }
        },
        (_) {
          Get.back();
          print('✅ Working hours added successfully');
          Get.snackbar('Success'.tr, 'Working hours added successfully!'.tr);
        },
      );
    } catch (e) {
      print('❌ Exception adding working hours: $e');
      Get.snackbar('Error'.tr, 'Failed to add working hours.'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> getFilteredEmployeesForTab(int tabIndex) {
    String role = tabIndex == 0 ? 'PHARMACY_EMPLOYEE' : 'PHARMACY_TRAINEE';
    return employees
        .where((e) => e.roleName == role)
        .where((e) {
          if (selectedFilter.value == 'all') return true;
          if (selectedFilter.value == 'active') return e.status == 'ACTIVE';
          if (selectedFilter.value == 'inactive') return e.status == 'INACTIVE';
          return true;
        })
        .map((e) => {
              "id": e.id,
              "firstName": e.firstName,
              "lastName": e.lastName,
              "status": e.status,
              "dateOfHire": e.dateOfHire,
              "roleName": e.roleName,
              'email': e.email,
              "phoneNumber": e.phoneNumber,
              "workingHours": e.workingHoursRequests,
            })
        .toList();
  }

  Future<void> refreshEmployees() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    fetchAllEmployees();
    isLoading.value = false;
  }

  void initTabController(TickerProvider ticker) {
    tabController = TabController(length: 2, vsync: ticker);
  }

  Future<void> fetchAllEmployees() async {
    print('fetchAllEmployees called');
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _getAllEmployees();
      result.fold((failure) {
        if (failure.statusCode == 500) {
          errorMessage.value =
              'An unexpected error occurred. Please try again.'.tr;
          Get.snackbar('Error'.tr, errorMessage.value);
        } else {
          errorMessage.value = failure.errMessage;
          Get.snackbar('Errors'.tr, errorMessage.value);
        }
      }, (employeeList) {
        print('✅ Employees fetched: ${employeeList.length}');
        for (var emp in employeeList) {
          print('Employee: ${emp.firstName} ${emp.lastName}');
        }
        employees.assignAll(employeeList);
      });
    } catch (e) {
      print('💥 Unexpected error while fetching employees: $e');
      errorMessage.value = 'An unexpected error occurred. Please try again.'.tr;
      Get.snackbar('Error'.tr, errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEmployeeById(
    int employeeId,
  ) async {
    print('fetch Employees called');
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _getEmployeeById(employeeId: employeeId);
      result.fold((failure) {
        print('❌ Error fetching employee : ${failure.errMessage}');
        if (failure.statusCode == 500) {
          errorMessage.value =
              'An unexpected error occurred. Please try again.'.tr;
          Get.snackbar('Error'.tr, errorMessage.value);
        } else {
          errorMessage.value = failure.errMessage;
          Get.snackbar('Errors'.tr, errorMessage.value);
        }
      }, (currEmployee) {
        employee.value = currEmployee;
        print(
            '📧 Employee email from response: ${currEmployee.email}'); // 👈 هون
      });
    } catch (e) {
      print('💥 Unexpected error while fetching employees: $e');
      errorMessage.value = 'An unexpected error occurred. Please try again.'.tr;
      Get.snackbar('Error'.tr, errorMessage.value);
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
          Get.snackbar('Error'.tr, failure.errMessage);
        },
        (updatedEmployee) {
          employee.value = updatedEmployee;
          Get.snackbar('Success'.tr, 'Employee updated successfully!'.tr);
          fetchEmployeeById(employeeId);
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
        },
      );
    } catch (e) {
      print('❌ Error editing employee: $e');
      errorMessage.value = 'Failed to update employee.'.tr;
      Get.snackbar('Error'.tr, errorMessage.value);
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
          Get.snackbar('Error'.tr, failure.errMessage);
        },
        (_) {
          Get.snackbar('Success'.tr, 'Employee deleted successfully!'.tr);
          fetchAllEmployees();
        },
      );
    } catch (e) {
      print('❌ Error deleting employee: $e');
      errorMessage.value = 'Failed to delete employee.'.tr;
      Get.snackbar('Error'.tr, errorMessage.value);
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

    super.onClose();
  }
}
