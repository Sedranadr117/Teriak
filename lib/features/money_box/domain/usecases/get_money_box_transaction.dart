import 'package:dartz/dartz.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_transaction_entity.dart';
import '../../../../../core/errors/failure.dart';
import '../repositories/get_money_box_transaction_repository.dart';

class GetMoneyBoxTransactions {
  final MoneyBoxTransactionRepository repository;

  GetMoneyBoxTransactions({required this.repository});

  Future<Either<Failure, MoneyBoxTransactionPaginatedEntity>> call({required GetMoneyBoxTransactionParams params}) {
    return repository.getMoneyBoxTransactions(params:params);
  }
}
