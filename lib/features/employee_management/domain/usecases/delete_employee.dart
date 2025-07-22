import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/employee_repository.dart';

class DeleteEmployee {
  final EmployeeRepository repository;
  DeleteEmployee(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deleteEmployee(id);
  }
}
