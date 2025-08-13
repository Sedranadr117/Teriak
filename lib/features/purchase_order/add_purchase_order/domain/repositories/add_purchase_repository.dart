import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/purchase_entity%20.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

abstract class AddPurchaseOrderRepository {
  Future<Either<Failure, PurchaseOrderEntity>> postAddPurchaseOrder(
      {required LanguageParam params, required Map<String, dynamic> body});
}
