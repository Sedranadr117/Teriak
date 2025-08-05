import 'package:dartz/dartz.dart';
import 'package:teriak/features/suppliers/all_supplier/domain/entities/supplier_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../repositories/edit_supplier_repository.dart';

class PutEditSupplier {
  final EditSupplierRepository repository;

  PutEditSupplier({required this.repository});

  Future<Either<Failure, SupplierEntity>> call(
      {required SupplierParams params,required Map<String, dynamic> body}) {
    return repository.putEditSupplier(params: params,body:body);
  }
}
