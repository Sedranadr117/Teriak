import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/entities/paginated_purchase_invoice_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../repositories/all_purchase_invoice_repository.dart';

class GetAllPurchaseInvoice {
  final AllPurchaseInvoiceRepository repository;

  GetAllPurchaseInvoice({required this.repository});

  Future<Either<Failure, PaginatedInvoiceEntity>> call(
      {required PaginationParams params}) {
    return repository.getAllPurchaseInvoice(params: params);
  }
}
