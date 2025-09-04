import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/features/sales_management/domain/entities/refund_entity.dart';
import 'package:teriak/features/sales_management/domain/repositories/sale_repository.dart';

class GetRefundsUseCase {
  final SaleRepository repository;
  GetRefundsUseCase({required this.repository});

  Future<Either<Failure, List<SaleRefundEntity>>> call() {
    return repository.getRefunds();
  }
}
