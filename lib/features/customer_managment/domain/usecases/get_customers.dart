import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import '../entities/customer_entity.dart';
import '../repositories/customer_repository.dart';

class GetCustomers {
  final CustomerRepository repository;

  GetCustomers({required this.repository});

  Future<Either<Failure, List<CustomerEntity>>> call() async {
    return await repository.getCustomers();
  }
}
