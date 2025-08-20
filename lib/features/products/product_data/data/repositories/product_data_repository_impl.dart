import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/products/product_data/domain/entities/product_names_entity.dart';

import '../../../../../core/connection/network_info.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../domain/entities/product_data_entity.dart';
import '../../domain/repositories/product_data_repository.dart';
import '../datasources/product_data_remote_data_source.dart';

class ProductDataRepositoryImpl extends ProductDataRepository {
  final NetworkInfo networkInfo;
  final ProductDataRemoteDataSource remoteDataSource;
  ProductDataRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, List<ProductDataEntity>>> getProductData({
    required ProductDataParams params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProductData = await remoteDataSource.getProductData(params);
        return Right(remoteProductData);
      } on ServerException catch (e) {
            return Left(Failure(
          errMessage: e.errorModel.errorMessage,
          statusCode: e.errorModel.status,
        ));
      }
    } else {
      return Left(Failure(errMessage: 'No internet connection'));
    }
  }
  @override
  Future<Either<Failure,ProductNamesEntity>> getProductNames({
    required ProductNamesParams params,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProductData = await remoteDataSource.getProductNames(params);
        return Right(remoteProductData);
      } on ServerException catch (e) {
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
