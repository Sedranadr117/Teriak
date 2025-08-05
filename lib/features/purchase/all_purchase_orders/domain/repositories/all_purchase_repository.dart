import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase/all_purchase_orders/domain/entities/purchase_entity%20.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

abstract class AllPurchaseOrdersRepository {
  Future<Either<Failure, List<PurchaseOrderEntity>>> getAllPurchaseOrders(
      {required LanguageParam params});
}
