import 'package:dartz/dartz.dart';
import 'package:teriak/features/stock_management/domain/repositories/stock_repository.dart';
import '../../../../core/errors/failure.dart';

class DeleteStock {
  final StockRepository repository;
  DeleteStock(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deleteStock(id);
  }
}
