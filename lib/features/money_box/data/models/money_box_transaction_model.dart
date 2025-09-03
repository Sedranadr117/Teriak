import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_transaction_entity.dart';

class MoneyBoxTransactionPaginatedModel
    extends MoneyBoxTransactionPaginatedEntity {
  MoneyBoxTransactionPaginatedModel(
      {required super.size,
      required super.page,
      required super.content,
      required super.totalElements,
      required super.totalPages,
      required super.hasNext,
      required super.hasPrevious});

  factory MoneyBoxTransactionPaginatedModel.fromJson(
      Map<String, dynamic> json) {
    return MoneyBoxTransactionPaginatedModel(
      content: (json['content'] as List<dynamic>?)
              ?.map((item) => MoneyBoxTransactionModel.fromJson(item))
              .toList() ??
          [],
      page: json['page'] ?? 0,
      size: json['size'] ?? 10,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNext: json['hasNext'] ?? false,
      hasPrevious: json['hasPrevious'] ?? false,
    );
  }
}

class MoneyBoxTransactionModel extends MoneyBoxTransactionEntity {
  MoneyBoxTransactionModel(
      {required super.id, 
      required super.transactionType,
      required super.amount,
      required super.balanceBefore,
      required super.balanceAfter,
      required super.description});


  factory MoneyBoxTransactionModel.fromJson(Map<String, dynamic> json) {
    return MoneyBoxTransactionModel(
      id: json[ApiKeys.id],
      transactionType: json[ApiKeys.transactionType],
      amount: json[ApiKeys.amount],
      balanceBefore: json[ApiKeys.balanceBefore],
      balanceAfter: json[ApiKeys.balanceAfter],
      description: json[ApiKeys.description],
    );
  }

}
