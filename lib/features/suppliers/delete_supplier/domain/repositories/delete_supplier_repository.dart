import 'package:dartz/dartz.dart';
import 'package:teriak/core/params/params.dart';
import '../../../../../core/errors/failure.dart';

abstract class DeleteSupplierRepository {
  Future<Either<Failure, void>> deleteSupplier(
      {required SupplierParams params});
}
