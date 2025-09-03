import 'package:dartz/dartz.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_transaction_entity.dart';
import '../../../../../core/errors/failure.dart';

abstract class MoneyBoxTransactionRepository {
  Future<Either<Failure, MoneyBoxTransactionPaginatedEntity>> getMoneyBoxTransactions({required GetMoneyBoxTransactionParams params});
}
