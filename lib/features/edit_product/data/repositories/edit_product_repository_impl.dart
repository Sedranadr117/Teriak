import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import '../../../../../core/connection/network_info.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../domain/repositories/edit_product_repository.dart';
import '../datasources/edit_product_remote_data_source.dart';

class EditProductRepositoryImpl extends EditProductRepository {
  final NetworkInfo networkInfo;
  final EditProductRemoteDataSource remoteDataSource;
  EditProductRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, void>> putEditProduct(
      {required EditProductParams params,
      required Map<String, dynamic> body}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEditProduct =
            await remoteDataSource.putEditProduct(params, body);
        return Right(remoteEditProduct);
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
