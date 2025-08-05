import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/suppliers/all_supplier/domain/entities/supplier_entity.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../domain/repositories/edit_supplier_repository.dart';
import '../datasources/edit_supplier_remote_data_source.dart';

class EditSupplierRepositoryImpl extends EditSupplierRepository {
  final NetworkInfo networkInfo;
  final EditSupplierRemoteDataSource remoteDataSource;
  EditSupplierRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, SupplierEntity>> putEditSupplier(
      {required SupplierParams params,required Map<String, dynamic> body}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEditSupplier =
            await remoteDataSource.putEditSupplier(params,body);
        return Right(remoteEditSupplier);
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
