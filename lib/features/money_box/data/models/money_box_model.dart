
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_entity.dart';

class MoneyBoxModel extends MoneyBoxEntity {
  MoneyBoxModel({
   required super.id,
    required super.status,
    required super.lastReconciled,
    required super.totalBalanceInSYP,
    required super.totalBalanceInUSD,
    required super.currentUSDToSYPRate,
  });

  factory MoneyBoxModel.fromJson(Map<String, dynamic> json) {
    return MoneyBoxModel(
      id: json[ApiKeys.id],
      status: json[ApiKeys.status],
      lastReconciled: List<int>.from(json[ApiKeys.lastReconciled] ?? []),
      totalBalanceInSYP: json[ApiKeys.totalBalanceInSYP]??0.0,
      totalBalanceInUSD: json[ApiKeys.totalBalanceInUSD]??0.0,
      currentUSDToSYPRate: json[ApiKeys.currentUSDToSYPRate]??0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.status: status,
      ApiKeys.lastReconciled: lastReconciled,
      ApiKeys.totalBalanceInSYP: totalBalanceInSYP,
      ApiKeys.totalBalanceInUSD: totalBalanceInUSD,
      ApiKeys.currentUSDToSYPRate: currentUSDToSYPRate,
    };
  }

         DateTime get creationDateTime {
    if (lastReconciled.length >= 6) {
      return DateTime(
        lastReconciled[0], // year
        lastReconciled[1], // month
        lastReconciled[2], // day
        lastReconciled[3], // hour
        lastReconciled[4], // minute
        lastReconciled[5], // second
      );
    }
    return DateTime.now();
  }

  String get formattedCreationDateTime {
    final date = creationDateTime;
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    final formattedTime =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    return '$formattedDate, $formattedTime';
  }

}
