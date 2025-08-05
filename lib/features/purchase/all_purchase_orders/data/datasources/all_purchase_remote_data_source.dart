import 'package:teriak/features/purchase/all_purchase_orders/data/models/purchase_model%20.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class AllPurchaseOrdersRemoteDataSource {
  final ApiConsumer api;

  AllPurchaseOrdersRemoteDataSource({required this.api});
  Future<List<PurchaseOrderModel>> getAllPurchaseOrders(
      LanguageParam params) async {
    final response = await api.get(EndPoints.purchaseOrders,
        queryParameters: params.toMap());
    return (response as List<dynamic>)
        .map(
            (item) => PurchaseOrderModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
