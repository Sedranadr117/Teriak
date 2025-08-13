import 'package:dartz/dartz.dart';

import 'package:teriak/features/stock_management/domain/entities/Stock_entity.dart';
import 'package:teriak/features/stock_management/domain/repositories/stock_repository.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/params.dart';

class SearchStock {
  final StockRepository repository;

  SearchStock({required this.repository});

  Future<Either<Failure, List<StockEntity>>> call(
      {required SearchParams params}) {
    return repository.searchStock(params: params);
  }
}
