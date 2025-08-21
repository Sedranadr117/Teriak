import 'package:dartz/dartz.dart';
import 'package:teriak/core/params/params.dart';
import '../../../../../core/errors/failure.dart';

abstract class DeleteProductRepository {
  Future<Either<Failure, void>> deleteProduct({required DeleteProductParams params});
}
