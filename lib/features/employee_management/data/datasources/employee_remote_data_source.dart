import 'package:teriak/core/databases/api/api_consumer.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/employee_management/data/models/employee_model.dart';
import 'package:teriak/features/employee_management/data/models/role_id_model.dart';

class EmployeeRemoteDataSource {
  final ApiConsumer api;

  EmployeeRemoteDataSource({required this.api});

  Future<EmployeeModel> createEmployee(EmployeeParams params) async {
    try {
      final employeeData = {
        'firstName': params.firstName,
        'lastName': params.lastName,
        'password': params.password,
        'phoneNumber': params.phoneNumber,
        'status': params.status,
        'dateOfHire': params.dateOfHire,
        'roleId': params.roleId,
        'workingHoursRequests': [],
      };

      print('📤 Sending employee data: $employeeData');

      final response = await api.post(
        EndPoints.addEmployee,
        data: employeeData,
      );
      final employee = EmployeeModel.fromJson(response);
      print('✅ Employee created with ID: ${employee.id}');
      return employee;
    } catch (e) {
      print('❌ Error creating employee: $e');
      rethrow;
    }
  }

  Future<EmployeeModel> addWorkingHoursToEmployee({
    required int employeeId,
    required WorkingHoursRequestParams wParms,
  }) async {
    try {
      final workingHoursData = wParms.toJson();
      print(
          '🕒 Sending working hours for employee $employeeId: $workingHoursData');
      final workingHoursResponse = await api.post(
        'employees/$employeeId/working-hours',
        data: workingHoursData,
      );
      print('🟢 Working hours response: $workingHoursResponse');
      return EmployeeModel.fromJson(workingHoursResponse); // <-- Add this line
    } catch (e) {
      print('❌ Error adding working hours: $e');
      rethrow;
    }
  }

  Future<List<RoleModel>> getAllRoles() async {
    try {
      final response = await api.get(
        EndPoints.roleID,
      );

      final List data = response;
      return data.map((roleJson) => RoleModel.fromJson(roleJson)).toList();
    } catch (e) {
      print('❌ Error fetching roles: $e');
      rethrow;
    }
  }

  Future<List<EmployeeModel>> getAllEmployees() async {
    try {
      final response = await api.get(EndPoints.addEmployee);
      print('📥 Raw response from employees: $response');

      final List data = response;

      return data.map((e) => EmployeeModel.fromJson(e)).toList();
    } catch (e) {
      print('❌ Error fetching employees: $e');
      rethrow;
    }
  }

  Future<EmployeeModel> editEmployeeInfo(
      int employeeId, EmployeeParams params) async {
    try {
      final employeeData = {
        'firstName': params.firstName,
        'lastName': params.lastName,
        'password': params.password,
        'phoneNumber': params.phoneNumber,
        'status': params.status,
        'dateOfHire': params.dateOfHire,
        'roleId': params.roleId,
        'workingHoursRequests':
            params.workingHoursRequests.map((e) => e.toJson()).toList(),
      };

      print('📤 Sending employee data: $employeeData');

      final response = await api.put(
        'employees/$employeeId',
        data: employeeData,
      );
      return EmployeeModel.fromJson(response);
    } catch (e) {
      print('❌ Error in editing employee or adding working hours: $e');
      rethrow;
    }
  }

  Future<void> deleteEmployee(int id) async {
    try {
      final response = await api.delete('employees/$id');
      print(response);
    } catch (e) {
      print('❌ Error in deleting : $e');
      rethrow;
    }
  }
}
