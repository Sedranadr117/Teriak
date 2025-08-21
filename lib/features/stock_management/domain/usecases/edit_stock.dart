import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/stock_management/domain/entities/stock_entity.dart';

import 'package:teriak/features/stock_management/domain/repositories/stock_repository.dart';

class EditStock {
  final StockRepository repository;

  EditStock({required this.repository});

  Future<Either<Failure, StockEntity>> call(
      {required int id,
      required final int quantity,
      required final String expiryDate,
      required final int minStockLevel,
      required final String reasonCode,
      required final String additionalNotes}) {
    return repository.editStock(
      params: StockParams(
          id: id,
          quantity: quantity,
          expiryDate: expiryDate,
          reasonCode: reasonCode,
          additionalNotes: additionalNotes,
          minStockLevel: minStockLevel),
      stockItemeId: id,
    );
  }
}
