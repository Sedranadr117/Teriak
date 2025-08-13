import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/features/employee_management/domain/entities/employee_entity.dart';
import 'package:teriak/features/employee_management/domain/repositories/employee_repository.dart';

class GetEmployeeById {
  final EmployeeRepository repository;

  GetEmployeeById({required this.repository});

  Future<Either<Failure, EmployeeEntity>> call({
    required int employeeId,
  }) {
    return repository.getEmployeesById(employeeId: employeeId);
  }
}
