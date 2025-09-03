import 'package:dartz/dartz.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_entity.dart';
import '../../../../../core/errors/failure.dart';

abstract class MoneyBoxRepository {
  Future<Either<Failure, MoneyBoxEntity>> getMoneyBox();
}
