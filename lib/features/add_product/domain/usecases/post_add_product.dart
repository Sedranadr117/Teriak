import 'package:dartz/dartz.dart';
import 'package:teriak/features/add_product/domain/repositories/add_product_repository.dart';
import 'package:teriak/features/master_product/domain/entities/product_entity.dart'
    show ProductEntity;

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class GetAddProduct {
  final AddProductRepository repository;

  GetAddProduct({required this.repository});

  Future<Either<Failure, ProductEntity>> call(
      {required AddProductParams params, required Map<String, dynamic> body}) {
    return repository.postAddProduct(params: params, body: body);
  }
}
