import 'package:dartz/dartz.dart';
import 'package:teriak/features/products/product_data/domain/entities/product_names_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../entities/product_data_entity.dart';
import '../repositories/product_data_repository.dart';

class GetProductData {
  final ProductDataRepository repository;

  GetProductData({required this.repository});

  Future<Either<Failure, List<ProductDataEntity>>>callData(
      {required ProductDataParams params}) {
    return repository.getProductData(params: params);
  }
  Future<Either<Failure, ProductNamesEntity>>callNames(
      {required ProductNamesParams params}) {
    return repository.getProductNames(params: params);
  }
}
