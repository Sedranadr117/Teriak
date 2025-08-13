import 'package:dartz/dartz.dart';
import 'package:teriak/features/stock_management/domain/entities/Stock_entity.dart';
import 'package:teriak/features/stock_management/domain/repositories/stock_repository.dart';

import '../../../../../core/errors/failure.dart';

class GetStock {
  final StockRepository repository;

  GetStock({required this.repository});

  Future<Either<Failure, List<StockEntity>>> call() {
    return repository.getStock();
  }
}
