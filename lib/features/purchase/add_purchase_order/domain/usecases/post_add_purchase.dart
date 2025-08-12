import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase/all_purchase_orders/domain/entities/purchase_entity%20.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../repositories/add_purchase_repository.dart';

class AddPurchaseOrder {
  final AddPurchaseOrderRepository repository;

  AddPurchaseOrder({required this.repository});

  Future<Either<Failure, PurchaseOrderEntity>> call(
      {required LanguageParam params, required Map<String, dynamic> body}) {
    return repository.postAddPurchaseOrder(params: params, body: body);
  }
}
