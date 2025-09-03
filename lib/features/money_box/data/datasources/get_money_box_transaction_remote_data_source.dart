import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/money_box/data/models/money_box_transaction_model.dart';
import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';

class MoneyBoxTransactionRemoteDataSource {
  final ApiConsumer api;

  MoneyBoxTransactionRemoteDataSource({required this.api});
  Future<MoneyBoxTransactionPaginatedModel> getMoneyBoxTransaction(
      GetMoneyBoxTransactionParams params) async {
    final response = await api.get(EndPoints.moneyBoxTransactions,
        queryParameters: params.toMap());
    return MoneyBoxTransactionPaginatedModel.fromJson(
        response as Map<String, dynamic>);
  }
}
