import 'package:teriak/features/money_box/data/models/money_box_model.dart';
import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';

class AddMoneyBoxRemoteDataSource {
  final ApiConsumer api;

  AddMoneyBoxRemoteDataSource({required this.api});
  Future<MoneyBoxModel> postMoneyBox(Map<String,dynamic> body) async {
    final response = await api.post(EndPoints.moneyBox,data: body);
    return MoneyBoxModel.fromJson(response);
  }
}
