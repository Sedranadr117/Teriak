import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/entities/purchase_invoice_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

abstract class AddPurchaseInvoiceRepository {
  Future<Either<Failure, PurchaseInvoiceEntity>> postAddPurchaseInvoice(
      {required LanguageParam params,required Map<String,dynamic> body});
}
