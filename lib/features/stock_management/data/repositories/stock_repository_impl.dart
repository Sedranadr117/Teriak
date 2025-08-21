import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/exceptions.dart';
import 'package:teriak/features/stock_management/data/datasources/Stock_remote_data_source.dart';
import 'package:teriak/features/stock_management/domain/entities/stock_entity.dart';
import 'package:teriak/features/stock_management/domain/entities/stock_item_entity.dart'
    show StockDetailsEntity;
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
      return Left(Failure(
        errMessage: e.toString(),
        statusCode: e.errorModel.status,
      ));
    }
  }

  @override
  Future<Either<Failure, List<StockEntity>>> searchStock(
      {required SearchStockParams params}) async {
    try {
      final remoteStock = await remoteDataSource.searchStock(params);
      return Right(remoteStock);
    } on ServerException catch (e) {
      return Left(Failure(
        errMessage: e.toString(),
        statusCode: e.errorModel.status,
      ));
    }
  }

  @override
  Future<Either<Failure, StockEntity>> editStock(
      {required int stockItemeId, required StockParams params}) async {
    try {
      final updatedStock =
          await remoteDataSource.editStock(stockItemeId, params);
      return Right(updatedStock);
    } on ServerException catch (e) {
      return Left(
        Failure(
          errMessage: e.toString(),
          statusCode: e.errorModel.status,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteStock(int id) async {
    try {
      await remoteDataSource.deleteStock(id);

      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        Failure(
          errMessage: e.toString(),
          statusCode: e.errorModel.status,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, StockDetailsEntity>> getDetailsStock(
      {required int productId, required String productType}) async {
    try {
      final details = await remoteDataSource.getDetailsStock(
        productId: productId,
        productType: productType,
      );

      return Right(details.toEntity());
    } on ServerException catch (e) {
      return Left(Failure(
        errMessage: e.toString(),
        statusCode: e.errorModel.status,
      ));
    }
  }
}
