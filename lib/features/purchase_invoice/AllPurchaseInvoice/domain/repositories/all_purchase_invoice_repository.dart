import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/entities/paginated_purchase_invoice_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

abstract class AllPurchaseInvoiceRepository {
  Future<Either<Failure, PaginatedInvoiceEntity>> getAllPurchaseInvoice(
      {required PaginationParams params});
}
