import 'package:dartz/dartz.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_entity.dart';
import 'package:teriak/features/money_box/domain/repositories/get_money_box_repository.dart';
import '../../../../../core/errors/failure.dart';

class GetMoneyBox {
  final MoneyBoxRepository repository;

  GetMoneyBox({required this.repository});

  Future<Either<Failure, MoneyBoxEntity>> call() {
    return repository.getMoneyBox();
  }
}
