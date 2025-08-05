import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/master_product/data/datasources/product_remote_data_source.dart';
import 'package:teriak/features/master_product/domain/repositories/product_repository.dart';

import '../../../../../core/connection/network_info.dart';

import '../../../../../core/errors/failure.dart';
import '../../domain/entities/product_entity.dart';

class ProductRepositoryImpl extends ProductRepository {
  final NetworkInfo networkInfo;
  final ProductRemoteDataSource remoteDataSource;
  ProductRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProduct(
      {required AllProductParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProduct = await remoteDataSource.getAllProduct(params);
        return Right(remoteProduct);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: 'No internet connection'));
    }
  }
}
