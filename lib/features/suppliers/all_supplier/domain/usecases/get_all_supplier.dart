import 'package:dartz/dartz.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import 'package:teriak/features/suppliers/all_supplier/domain/repositories/all_supplier_repository.dart';
import '../../../../../core/errors/failure.dart';


class GetAllSupplier {
  final AllSupplierRepository repository;

  GetAllSupplier({required this.repository});

  Future<Either<Failure, List<SupplierModel>>> call() {
    return repository.getAllSupplier();
  }
}
