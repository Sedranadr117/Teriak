import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/employee_management/domain/repositories/employee_repository.dart';

class AddWorkingHoursToEmployee {
  final EmployeeRepository repository;

  AddWorkingHoursToEmployee({required this.repository});

  Future<Either<Failure, void>> call({
    required int employeeId,
    required WorkingHoursRequestParams workingHours,
  }) async {
    return await repository.addWorkingHoursToEmployee(
      employeeId,
      workingHours,
    );
  }
}
