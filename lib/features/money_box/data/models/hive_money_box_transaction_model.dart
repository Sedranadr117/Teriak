import 'package:hive/hive.dart';
import 'package:teriak/features/money_box/data/models/money_box_transaction_model.dart';

part 'hive_money_box_transaction_model.g.dart';

@HiveType(typeId: 13)
class HiveMoneyBoxTransactionModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String transactionType;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final double balanceBefore;

  @HiveField(4)
  final double balanceAfter;

  @HiveField(5)
  final String description;

  HiveMoneyBoxTransactionModel({
    required this.id,
    required this.transactionType,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.description,
  });

  String get cacheKey => id.toString();

  factory HiveMoneyBoxTransactionModel.fromMoneyBoxTransactionModel(
      MoneyBoxTransactionModel model) {
    return HiveMoneyBoxTransactionModel(
      id: model.id,
      transactionType: model.transactionType,
      amount: model.amount,
      balanceBefore: model.balanceBefore,
      balanceAfter: model.balanceAfter,
      description: model.description,
    );
  }

  MoneyBoxTransactionModel toMoneyBoxTransactionModel() {
    return MoneyBoxTransactionModel(
      id: id,
      transactionType: transactionType,
      amount: amount,
      balanceBefore: balanceBefore,
      balanceAfter: balanceAfter,
      description: description,
    );
  }
}
