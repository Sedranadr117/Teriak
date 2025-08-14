import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase/all_purchase_orders/domain/entities/purchase_entity%20.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../repositories/edit_purchase_repository.dart';

class EditPurchaseOrders {
  final EditPurchaseOrdersRepository repository;

  EditPurchaseOrders({required this.repository});

  Future<Either<Failure, PurchaseOrderEntity>> call(
      {required EditPurchaseOrdersParams params,required Map<String, dynamic> body}) {
    return repository.putEditPurchaseOrders(params: params,body:body);
  }
}
