import 'package:dartz/dartz.dart';
import 'package:teriak/features/suppliers/all_supplier/domain/entities/supplier_entity.dart';
import 'package:teriak/features/suppliers/search_supplier/domain/repositories/search_supplier_repository.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class SearchSupplier {
  final SearchSupplierRepository repository;

  SearchSupplier({required this.repository});

  Future<Either<Failure, List<SupplierEntity>>> call(
      {required SearchSupplierParams params}) {
    return repository.searchSupplier(params: params);
  }
}
