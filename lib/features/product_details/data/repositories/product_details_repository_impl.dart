import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/master_product/domain/entities/product_entity.dart';
import 'package:teriak/features/product_details/data/datasources/product_details_remote_data_source.dart';
import 'package:teriak/features/product_details/domain/repositories/product_details_repository.dart';

import '../../../../../core/connection/network_info.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class ProductDetailsRepositoryImpl extends ProductDetailsRepository {
  final NetworkInfo networkInfo;
  final ProductDetailsRemoteDataSource remoteDataSource;
  ProductDetailsRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, ProductEntity>> getProductDetails(
      {required ProductDetailsParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProductDetails =
            await remoteDataSource.getProductDetails(params);
        return Right(remoteProductDetails);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: 'No internet connection'));
    }
  }
}
