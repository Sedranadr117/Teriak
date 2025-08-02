import 'package:dartz/dartz.dart';
import 'package:teriak/features/master_product/domain/entities/product_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

abstract class SearchProductRepository {
  Future<Either<Failure, List<ProductEntity>>> searchProduct(
      {required SearchProductParams params});
}
