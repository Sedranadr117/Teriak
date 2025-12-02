import 'package:hive/hive.dart';
import 'package:teriak/features/money_box/data/models/money_box_model.dart';

part 'hive_money_box_model.g.dart';

@HiveType(typeId: 12)
class HiveMoneyBoxModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String status;

  @HiveField(2)
  final List<int> lastReconciled;

  @HiveField(3)
  final double totalBalanceInSYP;

  @HiveField(4)
  final double totalBalanceInUSD;

  @HiveField(5)
  final int currentUSDToSYPRate;

  HiveMoneyBoxModel({
    required this.id,
    required this.status,
    required this.lastReconciled,
    required this.totalBalanceInSYP,
    required this.totalBalanceInUSD,
    required this.currentUSDToSYPRate,
  });

  String get cacheKey => id.toString();

  factory HiveMoneyBoxModel.fromMoneyBoxModel(MoneyBoxModel model) {
    return HiveMoneyBoxModel(
      id: model.id,
      status: model.status,
      lastReconciled: model.lastReconciled,
      totalBalanceInSYP: model.totalBalanceInSYP,
      totalBalanceInUSD: model.totalBalanceInUSD,
      currentUSDToSYPRate: model.currentUSDToSYPRate,
    );
  }

  MoneyBoxModel toMoneyBoxModel() {
    return MoneyBoxModel(
      id: id,
      status: status,
      lastReconciled: lastReconciled,
      totalBalanceInSYP: totalBalanceInSYP,
      totalBalanceInUSD: totalBalanceInUSD,
      currentUSDToSYPRate: currentUSDToSYPRate,
    );
  }
}
