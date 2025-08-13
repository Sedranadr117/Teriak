import 'package:dartz/dartz.dart';
import 'package:teriak/features/stock_management/domain/entities/Stock_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

abstract class StockRepository {
  Future<Either<Failure, List<StockEntity>>> getStock();
  Future<Either<Failure, List<StockEntity>>> searchStock(
      {required SearchParams params});
}
