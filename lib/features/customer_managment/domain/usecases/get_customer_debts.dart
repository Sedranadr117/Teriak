import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/features/customer_managment/domain/entities/customer_debts_entity.dart';
import 'package:teriak/features/customer_managment/domain/repositories/customer_repository.dart';

class GetCustomerDebts {
  final CustomerRepository repository;

  GetCustomerDebts({required this.repository});

  Future<Either<Failure, List<CustomerDebtEntity>>> call(
      {required int customerId}) async {
    return await repository.getCustomersDebts(customerId);
  }
}
