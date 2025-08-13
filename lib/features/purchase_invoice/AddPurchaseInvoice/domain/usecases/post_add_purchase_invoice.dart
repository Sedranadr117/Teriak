import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/entities/purchase_invoice_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../repositories/add_purchase_invoice_repository.dart';

class  AddPurchaseInvoice {
  final  AddPurchaseInvoiceRepository repository;

   AddPurchaseInvoice({required this.repository});

  Future<Either<Failure, PurchaseInvoiceEntity>> call(
      {required  LanguageParam params,required Map<String,dynamic> body}) {
    return repository.postAddPurchaseInvoice(params: params,body: body);
  }
}
