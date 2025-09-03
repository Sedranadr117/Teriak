import 'package:dartz/dartz.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_entity.dart';
import 'package:teriak/features/money_box/domain/repositories/add_money_box_repository.dart';
import '../../../../../core/errors/failure.dart';

class PostMoneyBox {
  final AddMoneyBoxRepository repository;

  PostMoneyBox({required this.repository});

  Future<Either<Failure, MoneyBoxEntity>> call({required Map<String, dynamic> body}) {
    return repository.postMoneyBox(body: body);
  }
}
