import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/stock_management/data/datasources/Stock_remote_data_source.dart';
import 'package:teriak/features/stock_management/domain/entities/Stock_entity.dart';
import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../domain/repositories/stock_repository.dart';

class StockRepositoryImpl extends StockRepository {
  final NetworkInfo networkInfo;
  final StockRemoteDataSource remoteDataSource;
  StockRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<StockEntity>>> getStock() async {
    try {
      final remoteStock = await remoteDataSource.getStock();
      return Right(remoteStock);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StockEntity>>> searchStock(
      {required SearchParams params}) async {
    try {
      final remoteStock = await remoteDataSource.searchStock(params);
      return Right(remoteStock);
    } on ServerException catch (e) {
      return Left(Failure(errMessage: e.toString()));
    }
  }
}
