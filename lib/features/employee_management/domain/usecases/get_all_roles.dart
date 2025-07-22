import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/features/employee_management/domain/entities/role_id_entity.dart';
import 'package:teriak/features/employee_management/domain/repositories/employee_repository.dart';

class GetAllRoles {
  final EmployeeRepository repository;

  GetAllRoles({required this.repository});

  Future<Either<Failure, List<RoleEntity>>> call() {
    return repository.getAllRoles();
  }
}
