import 'package:dartz/dartz.dart';
import 'package:teriak/features/stock_management/domain/entities/stock_entity.dart'
    show StockEntity;

import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';
import '../../../stock_management/domain/repositories/stock_repository.dart';

class SearchStock {
  final StockRepository repository;

  SearchStock({required this.repository});

  Future<Either<Failure, List<StockEntity>>> call(
      {required SearchStockParams params}) {
    return repository.searchStock(params: params);
  }
}
