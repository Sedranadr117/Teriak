import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/suppliers/all_supplier/data/datasources/all_supplier_remote_data_source.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import 'package:teriak/features/suppliers/all_supplier/domain/repositories/all_supplier_repository.dart';
import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';


class AllSupplierRepositoryImpl extends AllSupplierRepository {
  final NetworkInfo networkInfo;
  final AllSupplierRemoteDataSource remoteDataSource;
  AllSupplierRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, List<SupplierModel>>> getAllSupplier() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAllSupplier = await remoteDataSource.getAllSupplier();
        return Right(remoteAllSupplier);
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
