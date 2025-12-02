import 'package:hive/hive.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/money_box/data/models/hive_money_box_transaction_model.dart';
import 'package:teriak/features/money_box/data/models/money_box_transaction_model.dart';
import 'package:teriak/features/money_box/domain/entities/money_box_transaction_entity.dart';

abstract class MoneyBoxTransactionLocalDataSource {
  Future<void> cacheMoneyBoxTransactions(
      MoneyBoxTransactionPaginatedModel transactions, GetMoneyBoxTransactionParams params);
  MoneyBoxTransactionPaginatedEntity? getCachedMoneyBoxTransactions(
      GetMoneyBoxTransactionParams params);
  List<MoneyBoxTransactionEntity> getCachedMoneyBoxTransactionsList();
  Future<void> clearCachedMoneyBoxTransactions();
}

class MoneyBoxTransactionLocalDataSourceImpl
    implements MoneyBoxTransactionLocalDataSource {
  final Box<HiveMoneyBoxTransactionModel> transactionBox;

  MoneyBoxTransactionLocalDataSourceImpl({required this.transactionBox});

  @override
  Future<void> cacheMoneyBoxTransactions(
      MoneyBoxTransactionPaginatedModel transactions,
      GetMoneyBoxTransactionParams params) async {
    // Cache each transaction
    for (final transaction in transactions.content) {
      final hiveTransaction =
          HiveMoneyBoxTransactionModel.fromMoneyBoxTransactionModel(
              transaction as MoneyBoxTransactionModel);
      final cacheKey = hiveTransaction.cacheKey;
      await transactionBox.put(cacheKey, hiveTransaction);
    }
    print('✅ Cached ${transactions.content.length} money box transactions');
  }

  @override
  MoneyBoxTransactionPaginatedEntity? getCachedMoneyBoxTransactions(
      GetMoneyBoxTransactionParams params) {
    final allTransactions = getCachedMoneyBoxTransactionsList();
    
    if (allTransactions.isEmpty) {
      return null;
    }

    // Apply filters if provided
    var filteredTransactions = allTransactions;
    
    if (params.startDate != null || params.endDate != null) {
      // Note: We don't have date field in transaction entity
      // This is a simplified version - you may need to add date field
      filteredTransactions = allTransactions;
    }

    // Apply pagination
    final total = filteredTransactions.length;
    final page = params.page;
    final size = params.size;
    final startIndex = page * size;
    final endIndex = startIndex + size;

    if (startIndex >= total) {
      return MoneyBoxTransactionPaginatedEntity(
        content: [],
        page: page,
        size: size,
        totalElements: total,
        totalPages: (total / size).ceil(),
        hasNext: false,
        hasPrevious: page > 0,
      );
    }

    final paginatedTransactions = filteredTransactions.sublist(
      startIndex,
      endIndex > total ? total : endIndex,
    );

    print('📦 Returning ${paginatedTransactions.length} cached money box transactions (page $page)');
    
    return MoneyBoxTransactionPaginatedEntity(
      content: paginatedTransactions,
      page: page,
      size: size,
      totalElements: total,
      totalPages: (total / size).ceil(),
      hasNext: endIndex < total,
      hasPrevious: page > 0,
    );
  }

  @override
  List<MoneyBoxTransactionEntity> getCachedMoneyBoxTransactionsList() {
    final transactions = transactionBox.values
        .map((hiveTransaction) => hiveTransaction.toMoneyBoxTransactionModel())
        .toList();
    
    // Sort by ID descending (newest first)
    transactions.sort((a, b) => b.id.compareTo(a.id));
    
    return transactions;
  }

  @override
  Future<void> clearCachedMoneyBoxTransactions() async {
    await transactionBox.clear();
    print('🧹 Cleared cached money box transactions');
  }
}

