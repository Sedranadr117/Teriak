import 'package:dartz/dartz.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/products/all_products/domain/entities/paginated_products_entity.dart';
import '../../../../../core/errors/failure.dart';

abstract class ProductRepository {
  Future<Either<Failure, PaginatedProductsEntity>> getAllProduct({required AllProductParams params});
}
