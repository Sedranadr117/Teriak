import 'package:dartz/dartz.dart';
import 'package:teriak/features/suppliers/all_supplier/domain/entities/supplier_entity.dart';
import 'package:teriak/features/suppliers/details_supplier/domain/repositories/details_suppliere_repository.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';


class GetDetailsSupplier {
  final DetailsSupplierRepository repository;

  GetDetailsSupplier({required this.repository});

  Future<Either<Failure, SupplierEntity>> call(
      {required SupplierParams params}) {
    return repository.getDetailsSupplier(params: params);
  }
}
