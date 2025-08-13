import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import '../entities/customer_entity.dart';
import '../repositories/customer_repository.dart';

class CreateCustomer {
  final CustomerRepository repository;

  CreateCustomer({required this.repository});

  Future<Either<Failure, CustomerEntity>> call(
      {required String name,
      required String phoneNumber,
      required String address,
      required String notes}) async {
    return await repository.createCustomer(CustomerParams(
        notes: notes, name: name, phoneNumber: phoneNumber, address: address));
  }
}
