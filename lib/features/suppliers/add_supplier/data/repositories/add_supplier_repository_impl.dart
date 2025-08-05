import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/suppliers/add_supplier/data/datasources/add_supplier_remote_data_source.dart';
import 'package:teriak/features/suppliers/add_supplier/domain/repositories/add_supplier_repository.dart';
import 'package:teriak/features/suppliers/all_supplier/domain/entities/supplier_entity.dart';
import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';



class AddSupplierRepositoryImpl extends AddSupplierRepository {
  final NetworkInfo networkInfo;
  final AddSupplierRemoteDataSource remoteDataSource;
  AddSupplierRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, SupplierEntity>> postAddSupplier(
      {required Map<String, dynamic> body}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAddSupplier = await remoteDataSource.postAddSupplier(body);
        return Right(remoteAddSupplier);
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
