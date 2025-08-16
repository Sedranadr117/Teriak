import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../entities/product_data_entity.dart';

abstract class ProductDataRepository {
  Future<Either<Failure, List<ProductDataEntity>>> getProductData(
      {required ProductDataParams params});
}
