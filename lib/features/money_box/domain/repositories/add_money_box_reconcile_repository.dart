import 'package:dartz/dartz.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_entity.dart';
import '../../../../../core/errors/failure.dart';

abstract class AddMoneyBoxReConcileRepository {
  Future<Either<Failure, MoneyBoxEntity>> postMoneyBoxReConcile({required ReconcileMoneyBoxParams params});
}
