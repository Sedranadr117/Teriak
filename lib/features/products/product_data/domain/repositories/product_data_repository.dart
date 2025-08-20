import 'package:dartz/dartz.dart';
import 'package:teriak/features/products/product_data/domain/entities/product_names_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../entities/product_data_entity.dart';

abstract class ProductDataRepository {
  Future<Either<Failure, List<ProductDataEntity>>> getProductData(
      {required ProductDataParams params});

  Future<Either<Failure,ProductNamesEntity>> getProductNames(
      {required ProductNamesParams params});
}
