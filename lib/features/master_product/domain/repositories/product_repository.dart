import 'package:dartz/dartz.dart';
import 'package:teriak/core/params/params.dart';
import '../../../../../core/errors/failure.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getAllProduct({required AllProductParams params});
}
