import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/entities/purchase_invoice_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

abstract class EditPurchaseInvoiceRepository {
  Future<Either<Failure, PurchaseInvoiceEntity>> putEditPurchaseInvoice(
      {required EditPurchaseInvoiceParams params,required Map<String,dynamic> body});
}
