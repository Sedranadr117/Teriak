import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/employee_management/domain/entities/employee_entity.dart';

abstract class AddEmployeeRepository {
  Future<Either<Failure, EmployeeEntity>> addEmployee(
      {required EmployeeParams params});
}
