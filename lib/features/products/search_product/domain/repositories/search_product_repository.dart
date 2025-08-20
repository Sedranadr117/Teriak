import 'package:dartz/dartz.dart';
import 'package:teriak/features/products/all_products/domain/entities/paginated_products_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

abstract class SearchProductRepository {
  Future<Either<Failure, PaginatedProductsEntity>> searchProduct(
      {required SearchProductParams params});
}
