import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/features/Sales_management/domain/repositories/sale_repository.dart';
import 'package:teriak/features/sales_management/domain/entities/invoice_entity.dart';

class GetInvoices {
  final SaleRepository repository;

  GetInvoices({required this.repository});
  Future<Either<Failure, List<InvoiceEntity>>> call() {
    return repository.getAllSales();
  }
}
