import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/entities/paginated_purchase_invoice_entity.dart';
import 'package:teriak/features/purchase_invoice/SearchPurchaseInvoice/domain/repositories/search_purchase_invoice_repository.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class GetSearchPurchaseInvoice {
  final SearchPurchaseInvoiceRepository repository;

  GetSearchPurchaseInvoice({required this.repository});

  Future<Either<Failure, PaginatedInvoiceEntity>> callBySupplier(
      {required SearchBySupplierParams params}) {
    return repository.getSearchPurchaseInvoiceBySupplier(params: params);
  }

  Future<Either<Failure, PaginatedInvoiceEntity>> callByDateRange(
      {required SearchByDateRangeParams params}) {
    return repository.getSearchPurchaseInvoiceByDateRange(params: params);
  }
}
