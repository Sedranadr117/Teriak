import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/sales_management/domain/entities/refund_entity.dart';
import 'package:teriak/features/sales_management/domain/repositories/sale_repository.dart';

class CreateRefund {
  final SaleRepository repository;

  CreateRefund({required this.repository});

  Future<Either<Failure, SaleRefundEntity>> call({
    required int saleInvoiceId,
    required SaleRefundParams params,
  }) {
    return repository.createRefund(
        saleInvoiceId: saleInvoiceId, params: params);
  }
}
