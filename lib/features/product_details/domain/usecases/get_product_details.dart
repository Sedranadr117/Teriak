import 'package:dartz/dartz.dart';
import 'package:teriak/features/master_product/domain/entities/product_entity.dart';
import 'package:teriak/features/product_details/domain/repositories/product_details_repository.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class GetProductDetails {
  final ProductDetailsRepository repository;

  GetProductDetails({required this.repository});

  Future<Either<Failure, ProductEntity>> call(
      {required ProductDetailsParams params}) {
    return repository.getProductDetails(params: params);
  }
}
