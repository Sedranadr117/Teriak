import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/paginated_purchase_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../repositories/search_purchase_order_repository.dart';

class GetSearchPurchaseOrder {
  final SearchPurchaseOrderRepository repository;

  GetSearchPurchaseOrder({required this.repository});

  Future<Either<Failure, PaginatedPurchaseOrderEntity>> callSupplier(
      {required SearchBySupplierParams params}) {
    return repository.getSearchPurchaseOrderBySupplier(params: params);
  }
  Future<Either<Failure, PaginatedPurchaseOrderEntity>> callDate(
      {required SearchByDateRangeParams params}) {
    return repository.getSearchPurchaseOrderByDateRange(params: params);
  }
}
