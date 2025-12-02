import 'package:hive/hive.dart';
import 'package:teriak/features/money_box/data/models/hive_money_box_model.dart';
import 'package:teriak/features/money_box/data/models/money_box_model.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_entity.dart';

abstract class MoneyBoxLocalDataSource {
  Future<void> cacheMoneyBox(MoneyBoxModel moneyBox);
  MoneyBoxEntity? getCachedMoneyBox();
  Future<void> clearCachedMoneyBox();
}

class MoneyBoxLocalDataSourceImpl implements MoneyBoxLocalDataSource {
  final Box<HiveMoneyBoxModel> moneyBoxBox;

  MoneyBoxLocalDataSourceImpl({required this.moneyBoxBox});

  @override
  Future<void> cacheMoneyBox(MoneyBoxModel moneyBox) async {
    final hiveMoneyBox = HiveMoneyBoxModel.fromMoneyBoxModel(moneyBox);
    final cacheKey = hiveMoneyBox.cacheKey;
    await moneyBoxBox.put(cacheKey, hiveMoneyBox);
    print('✅ Cached money box: ID ${moneyBox.id}');
  }

  @override
  MoneyBoxEntity? getCachedMoneyBox() {
    if (moneyBoxBox.isEmpty) {
      return null;
    }
    // Get the first (and should be only) money box
    final hiveMoneyBox = moneyBoxBox.values.first;
    print('📦 Returning cached money box: ID ${hiveMoneyBox.id}');
    return hiveMoneyBox.toMoneyBoxModel();
  }

  @override
  Future<void> clearCachedMoneyBox() async {
    await moneyBoxBox.clear();
    print('🧹 Cleared cached money box');
  }
}
