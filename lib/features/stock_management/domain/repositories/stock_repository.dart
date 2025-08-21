import 'package:dartz/dartz.dart';
import 'package:teriak/features/stock_management/domain/entities/stock_entity.dart';
import 'package:teriak/features/stock_management/domain/entities/stock_item_entity.dart'
    show StockDetailsEntity;
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

abstract class StockRepository {
  Future<Either<Failure, List<StockEntity>>> getStock();
  Future<Either<Failure, StockDetailsEntity>> getDetailsStock({
    required int productId,
    required String productType,
  });
  Future<Either<Failure, List<StockEntity>>> searchStock(
      {required SearchStockParams params});
  Future<Either<Failure, StockEntity>> editStock({
    required int stockItemeId,
    required StockParams params,
  });
  Future<Either<Failure, void>> deleteStock(int id);
}
