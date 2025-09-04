import 'package:dartz/dartz.dart';
import 'package:teriak/features/suppliers/delete_supplier/domain/repositories/delete_supplier_repository.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class DeleteSupplier {
  final DeleteSupplierRepository repository;

  DeleteSupplier({required this.repository});

  Future<Either<Failure, void>> call({required SupplierParams params}) {
    return repository.deleteSupplier(params: params);
  }
}
