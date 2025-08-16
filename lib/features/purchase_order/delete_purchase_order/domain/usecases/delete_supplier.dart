import 'package:dartz/dartz.dart';
import 'package:teriak/features/purchase_order/delete_purchase_order/domain/repositories/delete_supplier_repository.dart';
import 'package:teriak/features/suppliers/all_supplier/domain/entities/supplier_entity.dart';
import 'package:teriak/features/suppliers/delete_supplier/domain/repositories/delete_supplier_repository.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class DeletePurchaseOrder {
  final DeletePurchaseOrderRepository repository;

  DeletePurchaseOrder({required this.repository});

  Future<Either<Failure, void>> call(
      {required DeletePurchaseOrderParams params}) {
    return repository.deletePurchaseOrder(params: params);
  }
}
