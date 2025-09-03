import 'package:dartz/dartz.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_entity.dart';
import 'package:teriak/features/money_box/domain/repositories/add_money_box_transaction_repository.dart';
import '../../../../../core/errors/failure.dart';

class PostMoneyBoxTransaction {
  final AddMoneyBoxTransactionRepository repository;

  PostMoneyBoxTransaction({required this.repository});

  Future<Either<Failure, MoneyBoxEntity>> call(
      {required MoneyBoxTransactionParams params}) {
    return repository.postMoneyBoxTransaction(params: params);
  }
}
