import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/entities/purchase_invoice_entity.dart';
import 'package:teriak/features/purchase_invoice/PurchaseInvoiceDetails/domain/repositories/purchase_invoice_details_repository.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class GetPurchaseInvoiceDetails {
  final PurchaseInvoiceDetailsRepository repository;

  GetPurchaseInvoiceDetails({required this.repository});

  Future<Either<Failure, PurchaseInvoiceEntity>> call(
      {required PurchaseInvoiceDetailsParams params}) {
    return repository.getPurchaseInvoiceDetails(params: params);
  }
}
