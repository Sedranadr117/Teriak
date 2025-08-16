import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart' show ServerException;
import 'package:teriak/features/products/all_products/domain/entities/product_entity.dart';
import 'package:teriak/features/products/search_product/data/datasources/search_product_remote_data_source.dart';
import 'package:teriak/features/products/search_product/domain/repositories/search_product_repository.dart';
import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class SearchProductRepositoryImpl extends SearchProductRepository {
  final NetworkInfo networkInfo;
  final SearchProductRemoteDataSource remoteDataSource;

  SearchProductRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, List<ProductEntity>>> searchProduct(
      {required SearchProductParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSearchProduct =
            await remoteDataSource.searchProduct(params);

        return Right(remoteSearchProduct);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: 'No internet connection'));
    }
  }
}
