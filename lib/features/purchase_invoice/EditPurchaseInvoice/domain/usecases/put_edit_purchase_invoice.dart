import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/entities/purchase_invoice_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../repositories/edit_purchase_invoice_repository.dart';

class GetEditPurchaseInvoice {
  final EditPurchaseInvoiceRepository repository;

  GetEditPurchaseInvoice({required this.repository});

  Future<Either<Failure,PurchaseInvoiceEntity>> call(
      {required EditPurchaseInvoiceParams params,required Map<String,dynamic> body}) {
    return repository.putEditPurchaseInvoice(params: params,body:body);
  }
}
