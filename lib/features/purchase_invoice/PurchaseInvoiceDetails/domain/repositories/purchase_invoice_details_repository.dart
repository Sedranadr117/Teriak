import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/entities/purchase_invoice_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

abstract class PurchaseInvoiceDetailsRepository {
  Future<Either<Failure, PurchaseInvoiceEntity>>
      getPurchaseInvoiceDetails({required PurchaseInvoiceDetailsParams params});
}
