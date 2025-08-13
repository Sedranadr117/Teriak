import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import '../entities/customer_entity.dart';

abstract class CustomerRepository {
  Future<Either<Failure, List<CustomerEntity>>> getCustomers();
  Future<Either<Failure, CustomerEntity>> createCustomer(CustomerParams params);
  Future<Either<Failure, List<CustomerEntity>>> searchCustomer(
      {required SearchParams params});
  Future<Either<Failure, void>> deleteCustomer(int id);
  Future<Either<Failure, CustomerEntity>> editCustomer({
    required int customereId,
    required CustomerParams params,
  });
}
