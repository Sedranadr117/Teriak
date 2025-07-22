import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/features/employee_management/domain/entities/employee_entity.dart';
import 'package:teriak/features/employee_management/domain/repositories/employee_repository.dart';

class GetAllEmployees {
  final EmployeeRepository repository;

  GetAllEmployees({required this.repository});

  Future<Either<Failure, List<EmployeeEntity>>> call() {
    return repository.getAllEmployees();
  }
}
