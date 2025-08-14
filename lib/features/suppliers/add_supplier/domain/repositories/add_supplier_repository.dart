import 'package:dartz/dartz.dart';
import 'package:teriak/features/suppliers/all_supplier/domain/entities/supplier_entity.dart';
import '../../../../../core/errors/failure.dart';
abstract class AddSupplierRepository {
  Future<Either<Failure, SupplierEntity>> postAddSupplier(
      {required Map<String, dynamic> body});
}
