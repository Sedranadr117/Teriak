// ignore_for_file: public_member_api_docs, sort_constructors_first

class MoneyBoxTransactionPaginatedEntity {
  final int size;
  final int page;
  final List<MoneyBoxTransactionEntity> content;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  MoneyBoxTransactionPaginatedEntity({
    required this.size,
    required this.page,
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });
}

class MoneyBoxTransactionEntity {
  final int id;
  final String transactionType;
  final double amount;
  final double balanceBefore;
  final double balanceAfter;
  final String description;

  MoneyBoxTransactionEntity({
    required this.id,
    required this.transactionType,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.description,
  });
}
