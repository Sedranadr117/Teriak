import 'package:dartz/dartz.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_entity.dart';
import 'package:teriak/features/money_box/domain/repositories/add_money_box_reconcile_repository.dart';
import '../../../../../core/errors/failure.dart';

class PostMoneyBoxReConcile {
  final AddMoneyBoxReConcileRepository repository;

  PostMoneyBoxReConcile({required this.repository});

  Future<Either<Failure, MoneyBoxEntity>> call(
      {required ReconcileMoneyBoxParams params}) {
    return repository.postMoneyBoxReConcile(params: params);
  }
}
