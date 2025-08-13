import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/sales_management/domain/entities/invoice_entity.dart';

abstract class SaleRepository {
  Future<Either<Failure, InvoiceEntity>> createSalelProcess(
      SaleProcessParams parms);
  Future<Either<Failure, void>> cancelSalelProcess(int saleId);
  Future<Either<Failure, List<InvoiceEntity>>> getAllSales();
}
