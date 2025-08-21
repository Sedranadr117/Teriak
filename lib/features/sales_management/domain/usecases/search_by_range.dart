import 'package:dartz/dartz.dart';
import 'package:teriak/features/sales_management/domain/entities/invoice_entity.dart';
import 'package:teriak/features/sales_management/domain/repositories/sale_repository.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class SearchByRange {
  final SaleRepository repository;

  SearchByRange({required this.repository});

  Future<Either<Failure, List<InvoiceEntity>>> call(
      {required SearchInvoiceByDateRangeParams params}) {
    return repository.searchInvoiceByDateRange(params: params);
  }
}
