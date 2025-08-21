import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/features/stock_management/domain/entities/stock_item_entity.dart';
import 'package:teriak/features/stock_management/domain/repositories/stock_repository.dart';

class GetDetailsStock {
  final StockRepository repository;

  GetDetailsStock(this.repository);

  Future<Either<Failure, StockDetailsEntity>> call({
    required int productId,
    required String productType,
  }) async {
    return await repository.getDetailsStock(
      productId: productId,
      productType: productType,
    );
  }
}
