import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/employee_management/domain/entities/employee_entity.dart';
import 'package:teriak/features/employee_management/domain/repositories/add_employee_repository.dart';

class AddEmployee {
  final AddEmployeeRepository repository;

  AddEmployee({required this.repository});

  Future<Either<Failure, EmployeeEntity>> call({
    required String firstName,
    required String lastName,
    required String password,
    required String phoneNumber,
    required String status,
    required DateTime dateOfHire,
    required int roleId,
    required WorkTimeParams workStart,
    required WorkTimeParams workEnd,
  }) {
    return repository.addEmployee(
      params: EmployeeParams(
        firstName,
        lastName,
        password,
        phoneNumber,
        status,
        dateOfHire,
        roleId,
        workStart,
        workEnd,
      ),
    );
  }
}
