import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/purchase_entity%20.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../repositories/details_purchase_repository.dart';

class GetDetailsPurchaseOrders {
  final DetailsPurchaseOrdersRepository repository;

  GetDetailsPurchaseOrders({required this.repository});

  Future<Either<Failure, PurchaseOrderEntity>> call(
      {required DetailsPurchaseOrdersParams params}) {
    return repository.getDetailsPurchaseOrders(params: params);
  }
}
