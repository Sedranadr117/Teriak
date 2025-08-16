import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/paginated_purchase_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../repositories/all_purchase_repository.dart';

class GetAllPurchaseOrders {
  final AllPurchaseOrdersRepository repository;

  GetAllPurchaseOrders({required this.repository});

  Future<Either<Failure, PaginatedPurchaseOrderEntity>> call(
      {required PaginationParams params}) {
    return repository.getAllPurchaseOrders(params: params);
  }
}
