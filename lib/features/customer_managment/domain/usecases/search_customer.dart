import 'package:dartz/dartz.dart';
import 'package:teriak/features/customer_managment/domain/entities/customer_entity.dart';
import 'package:teriak/features/customer_managment/domain/repositories/customer_repository.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class SearchCustomer {
  final CustomerRepository repository;

  SearchCustomer({required this.repository});

  Future<Either<Failure, List<CustomerEntity>>> call(
      {required SearchParams params}) {
    return repository.searchCustomer(params: params);
  }
}
