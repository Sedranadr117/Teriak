import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/features/stock_management/data/models/Stock_model.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/params/params.dart';

class StockRemoteDataSource {
  final ApiConsumer api;

  StockRemoteDataSource({required this.api});
  Future<List<StockModel>> getStock() async {
    final response = await api.get(EndPoints.getStock);
    final List data = response;
    return data.map((e) => StockModel.fromJson(response)).toList();
  }

  Future<List<StockModel>> searchStock(SearchParams params) async {
    final response = await api.get(
      EndPoints.searchCustomers,
      queryParameters: params.toMap(),
    );
    print('Query params: ${params.toMap()}');

    print(response);
    return (response as List).map((item) => StockModel.fromJson(item)).toList();
  }
}
