import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/products/add_product/data/datasources/add_product_remote_data_source.dart';
import 'package:teriak/features/products/add_product/domain/repositories/add_product_repository.dart';
import 'package:teriak/features/products/all_products/domain/entities/product_entity.dart';

import '../../../../../core/connection/network_info.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class AddProductRepositoryImpl extends AddProductRepository {
  final NetworkInfo networkInfo;
  final AddProductRemoteDataSource remoteDataSource;
  AddProductRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, ProductEntity>> postAddProduct(
      {required AddProductParams params,
      required Map<String, dynamic> body}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAddProduct =
            await remoteDataSource.postAddProduct(params, body);
        return Right(remoteAddProduct);
      } on ServerException catch (e) {
        print(e.errorModel.status);
        return Left(Failure(
          errMessage: e.errorModel.errorMessage,
          statusCode: e.errorModel.status,
        ));
      }
    } else {
      return Left(Failure(errMessage: 'No internet connection'));
    }
  }
}
