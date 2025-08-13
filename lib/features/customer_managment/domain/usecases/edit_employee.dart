import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/customer_managment/domain/entities/customer_entity.dart';
import 'package:teriak/features/customer_managment/domain/repositories/customer_repository.dart';

class EditCustomer {
  final CustomerRepository repository;

  EditCustomer({required this.repository});

  Future<Either<Failure, CustomerEntity>> call({
    required int id,
    required String name,
    required String phoneNumber,
    required String address,
    required String notes,
  }) {
    return repository.editCustomer(
      params: CustomerParams(
          name: name, phoneNumber: phoneNumber, address: address, notes: notes),
      customereId: id,
    );
  }
}
