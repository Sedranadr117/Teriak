import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/suppliers/delete_supplier/data/datasources/delete_supplier_remote_data_source.dart';
import 'package:teriak/features/suppliers/delete_supplier/domain/repositories/delete_supplier_repository.dart';
import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';

class DeleteSupplierRepositoryImpl extends DeleteSupplierRepository {
  final NetworkInfo networkInfo;
  final DeleteSupplierRemoteDataSource remoteDataSource;
  DeleteSupplierRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, void>> deleteSupplier(
      {required SupplierParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteDeleteSupplier =
            await remoteDataSource.deleteSupplier(params);
        return Right(remoteDeleteSupplier);
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
