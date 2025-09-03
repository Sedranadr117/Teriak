import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/purchase_entity%20.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

abstract class DetailsPurchaseOrdersRepository {
  Future<Either<Failure, PurchaseOrderEntity>> getDetailsPurchaseOrders(
      {required DetailsPurchaseOrdersParams params});
}
