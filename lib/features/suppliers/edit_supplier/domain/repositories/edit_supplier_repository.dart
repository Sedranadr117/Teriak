import 'package:dartz/dartz.dart';
import 'package:teriak/features/suppliers/all_supplier/domain/entities/supplier_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';


abstract class EditSupplierRepository {
  Future<Either<Failure, SupplierEntity>> putEditSupplier(
      {required SupplierParams params,required Map<String, dynamic> body});
}
