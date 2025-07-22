import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/employee_management/domain/entities/employee_entity.dart';
import 'package:teriak/features/employee_management/domain/entities/role_id_entity.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, EmployeeEntity>> createEmployee({
    required EmployeeParams params,
  });
  Future<Either<Failure, void>> addWorkingHoursToEmployee(
      int employeeId, WorkingHoursRequestParams wParms);
  Future<Either<Failure, List<RoleEntity>>> getAllRoles();
  Future<Either<Failure, List<EmployeeEntity>>> getAllEmployees();
  Future<Either<Failure, EmployeeEntity>> editEmployee({
    required int employeeId,
    required EmployeeParams params,
  });
  Future<Either<Failure, void>> deleteEmployee(int id);
}
