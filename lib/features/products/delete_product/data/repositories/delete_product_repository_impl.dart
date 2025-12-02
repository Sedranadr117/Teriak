import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/Products/delete_Product/domain/repositories/delete_Product_repository.dart';
import 'package:teriak/features/products/all_products/data/datasources/product_local_data_source.dart';
import 'package:teriak/features/products/delete_product/data/datasources/delete_product_remote_data_source.dart';
import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';

class DeleteProductRepositoryImpl extends DeleteProductRepository {
  final NetworkInfo networkInfo;
  final DeleteProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  DeleteProductRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> deleteProduct(
      {required DeleteProductParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteDeleteProduct =
            await remoteDataSource.deleteProduct(params);

        // Delete from cache after successful remote deletion
        await localDataSource.deleteCachedProduct(
            params.id, params.productType);

        return Right(remoteDeleteProduct);
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
