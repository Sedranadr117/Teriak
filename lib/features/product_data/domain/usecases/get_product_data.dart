import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../entities/product_data_entity.dart';
import '../repositories/product_data_repository.dart';

class GetProductData {
  final ProductDataRepository repository;

  GetProductData({required this.repository});

  Future<Either<Failure, List<ProductDataEntity>>>call(
      {required ProductDataParams params}) {
    return repository.getProductData(params: params);
  }
}
