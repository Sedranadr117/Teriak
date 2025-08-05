import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase/all_purchase_orders/domain/entities/purchase_entity%20.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../repositories/all_purchase_repository.dart';

class GetAllPurchaseOrders {
  final AllPurchaseOrdersRepository repository;

  GetAllPurchaseOrders({required this.repository});

  Future<Either<Failure, List<PurchaseOrderEntity>>> call(
      {required LanguageParam params}) {
    return repository.getAllPurchaseOrders(params: params);
  }
}
