import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/employee_management/domain/entities/employee_entity.dart';
import 'package:teriak/features/employee_management/domain/repositories/employee_repository.dart';

class EditEmployee {
  final EmployeeRepository repository;

  EditEmployee({required this.repository});

  Future<Either<Failure, EmployeeEntity>> call({
    required int id,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String status,
    required String dateOfHire,
    required int roleId,
    required List<WorkingHoursRequestParams> workStart,
    required List<String> daysOfWeek,
    required List<ShiftParams> shifts,
  }) {
    return repository.editEmployee(
        params: EmployeeParams(
          firstName,
          lastName,
          '',
          phoneNumber,
          status,
          dateOfHire,
          roleId,
          workStart,
        ),
        employeeId: id);
  }
}
