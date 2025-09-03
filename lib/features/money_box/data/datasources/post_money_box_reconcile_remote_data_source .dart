import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/money_box/data/models/money_box_model.dart';
import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';

class AddMoneyBoxReConcileRemoteDataSource {
  final ApiConsumer api;

  AddMoneyBoxReConcileRemoteDataSource({required this.api});
  Future<MoneyBoxModel> postMoneyBoxReConcile(ReconcileMoneyBoxParams params) async {
    final response = await api.post(EndPoints.moneyBoxReconcile,queryParameters: params.toMap());
    return MoneyBoxModel.fromJson(response);
  }
}
