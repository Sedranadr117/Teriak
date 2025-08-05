import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/suppliers/all_supplier/domain/entities/supplier_entity.dart';
import 'package:teriak/features/suppliers/search_supplier/data/datasources/search_supplier_remote_data_source.dart';
import 'package:teriak/features/suppliers/search_supplier/domain/repositories/search_supplier_repository.dart';
import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class SearchSupplierRepositoryImpl extends SearchSupplierRepository {
  final NetworkInfo networkInfo;
  final SearchSupplierRemoteDataSource remoteDataSource;

  SearchSupplierRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});
  @override
  Future<Either<Failure, List<SupplierEntity>>> searchSupplier(
      {required SearchSupplierParams params}) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSearchSupplier =
            await remoteDataSource.searchSupplier(params);

        return Right(remoteSearchSupplier);
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
