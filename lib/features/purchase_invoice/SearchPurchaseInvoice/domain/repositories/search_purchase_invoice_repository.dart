import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/entities/paginated_purchase_invoice_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

abstract class SearchPurchaseInvoiceRepository {
  Future<Either<Failure, PaginatedInvoiceEntity>>
      getSearchPurchaseInvoiceBySupplier(
          {required SearchBySupplierParams params});
  Future<Either<Failure, PaginatedInvoiceEntity>>
      getSearchPurchaseInvoiceByDateRange(
          {required SearchByDateRangeParams params});
}
