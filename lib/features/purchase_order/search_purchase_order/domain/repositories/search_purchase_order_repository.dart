import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/paginated_purchase_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

abstract class SearchPurchaseOrderRepository {
  Future<Either<Failure, PaginatedPurchaseOrderEntity>> getSearchPurchaseOrderBySupplier(
      {required SearchBySupplierParams params});
  Future<Either<Failure, PaginatedPurchaseOrderEntity>> getSearchPurchaseOrderByDateRange(
      {required SearchByDateRangeParams params});
}
