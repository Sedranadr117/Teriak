import 'package:dartz/dartz.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import '../../../../../core/errors/failure.dart';

abstract class AllSupplierRepository {
  Future<Either<Failure, List<SupplierModel>>> getAllSupplier({bool skipCache = false});
}
