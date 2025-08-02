import 'package:dartz/dartz.dart';
import 'package:teriak/core/errors/failure.dart';

abstract class SaleRepository {
  Future<void> createSalelProcess();
  Future<Either<Failure, void>> cancelSalelProcess(int saleId);
}
