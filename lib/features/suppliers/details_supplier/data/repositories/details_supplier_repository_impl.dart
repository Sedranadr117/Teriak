import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/suppliers/all_supplier/domain/entities/supplier_entity.dart';
import 'package:teriak/features/suppliers/details_supplier/data/datasources/details_supplier_remote_data_source.dart';
import 'package:teriak/features/suppliers/details_supplier/domain/repositories/details_suppliere_repository.dart';
import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';


class DetailsSupplierRepositoryImpl extends DetailsSupplierRepository {
  final NetworkInfo networkInfo;
  final DetailsSupplierRemoteDataSource remoteDataSource;
  DetailsSupplierRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, SupplierEntity>> getDetailsSupplier(
      {required SupplierParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteDetailsSupplier =
            await remoteDataSource.getDetailsSupplier(params);
        return Right(remoteDetailsSupplier);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: 'No internet connection'));
    }
  }
}
