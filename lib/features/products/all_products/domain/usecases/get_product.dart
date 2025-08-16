import 'package:dartz/dartz.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/products/all_products/domain/repositories/product_repository.dart';

import '../../../../../core/errors/failure.dart';
import '../entities/product_entity.dart';

class GetAllProduct {
  final ProductRepository repository;

  GetAllProduct({required this.repository});

  Future<Either<Failure, List<ProductEntity>>> call(
      {required AllProductParams params}) {
    return repository.getAllProduct(params: params);
  }
}
