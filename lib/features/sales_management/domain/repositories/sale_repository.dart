import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/sales_management/domain/entities/invoice_entity.dart';
import 'package:teriak/features/sales_management/domain/entities/refund_entity.dart';

abstract class SaleRepository {
  Future<Either<Failure, InvoiceEntity>> createSalelProcess(
      SaleProcessParams parms);
  Future<Either<Failure, List<InvoiceEntity>>> getAllSales();
  Future<Either<Failure, List<InvoiceEntity>>> searchInvoiceByDateRange(
      {required SearchInvoiceByDateRangeParams params});
  Future<Either<Failure, SaleRefundEntity>> createRefund({
    required int saleInvoiceId,
    required SaleRefundParams params,
  });

  Future<Either<Failure, List<SaleRefundEntity>>> getRefunds();
}
