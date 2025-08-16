import 'package:dartz/dartz.dart';
import 'package:teriak/features/products/all_products/domain/entities/product_entity.dart';
import 'package:teriak/features/products/search_product/domain/repositories/search_product_repository.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class SearchProduct {
  final SearchProductRepository repository;

  SearchProduct({required this.repository});

  Future<Either<Failure, List<ProductEntity>>> call(
      {required SearchProductParams params}) {
    return repository.searchProduct(params: params);
  }
}
