
import 'package:teriak/features/money_box/data/models/money_box_model.dart';
import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';

class MoneyBoxRemoteDataSource {
  final ApiConsumer api;

  MoneyBoxRemoteDataSource({required this.api});
  Future<MoneyBoxModel> getMoneyBox() async {
    final response = await api.get(EndPoints.moneyBox);
    return MoneyBoxModel.fromJson(response);
  }
}
