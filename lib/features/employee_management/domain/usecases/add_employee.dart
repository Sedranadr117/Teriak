import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/employee_management/domain/entities/employee_entity.dart';
import 'package:teriak/features/employee_management/domain/repositories/employee_repository.dart';

class AddEmployee {
  final EmployeeRepository repository;

  AddEmployee({required this.repository});

  Future<Either<Failure, EmployeeEntity>> call({
    required String firstName,
    required String lastName,
    required String password,
    required String phoneNumber,
    required String status,
    required String dateOfHire,
    required int roleId,
    required List<WorkingHoursRequestParams> workStart,
    required List<String> daysOfWeek,
    required List<ShiftParams> shifts,
  }) {
    return repository.createEmployee(
      params: EmployeeParams(
        firstName,
        lastName,
        password,
        phoneNumber,
        status,
        dateOfHire,
        roleId,
        workStart,
      ),
    );
  }
}
