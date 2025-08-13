import 'package:dartz/dartz.dart';
import 'package:teriak/features/customer_managment/domain/repositories/customer_repository.dart';
import '../../../../core/errors/failure.dart';

class DeleteCustomer {
  final CustomerRepository repository;
  DeleteCustomer(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deleteCustomer(id);
  }
}
