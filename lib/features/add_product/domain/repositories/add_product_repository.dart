import 'package:dartz/dartz.dart';
import 'package:teriak/features/master_product/domain/entities/product_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

abstract class AddProductRepository {
  Future<Either<Failure, ProductEntity>> postAddProduct(
      {required AddProductParams params, required Map<String, dynamic> body});
}
