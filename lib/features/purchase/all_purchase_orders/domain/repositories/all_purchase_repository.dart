import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase/all_purchase_orders/domain/entities/paginated_purchase_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

abstract class AllPurchaseOrdersRepository {
  Future<Either<Failure, PaginatedPurchaseOrderEntity>> getAllPurchaseOrders(
      {required PaginationParams params});
}
