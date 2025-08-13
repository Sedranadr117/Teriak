import 'package:dartz/dartz.dart';
import 'package:teriak/core/params/params.dart';
import '../../../../../core/errors/failure.dart';

abstract class DeletePurchaseOrderRepository {
  Future<Either<Failure, void>> deletePurchaseOrder(
      {required DeletePurchaseOrderParams params});
}
