import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/money_box/data/models/money_box_model.dart';
import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';

class AddMoneyBoxTransactionRemoteDataSource {
  final ApiConsumer api;

  AddMoneyBoxTransactionRemoteDataSource({required this.api});
  Future<MoneyBoxModel> postMoneyBoxTransaction(MoneyBoxTransactionParams params) async {
    final response = await api.post(EndPoints.moneyBoxTransactions,queryParameters: params.toMap());
    return MoneyBoxModel.fromJson(response);
  }
}
