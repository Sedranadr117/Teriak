import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/customer_managment/domain/entities/payment_entity.dart';
import 'package:teriak/features/customer_managment/domain/repositories/customer_repository.dart';

class AddPayment {
  final CustomerRepository repository;

  AddPayment({required this.repository});

  Future<Either<Failure, PaymentEntity>> call({
    required int customerId,
    required double totalPaymentAmount,
    required String paymentMethod,
    String notes = '',
  }) {
    return repository.addPayment(
        customerId,
        PaymentParams(
          totalPaymentAmount: totalPaymentAmount,
          paymentMethod: paymentMethod,
        ));
  }
}
