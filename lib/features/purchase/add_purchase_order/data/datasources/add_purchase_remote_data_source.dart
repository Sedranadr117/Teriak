import 'package:teriak/features/purchase/all_purchase_orders/data/models/purchase_model%20.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class AddPurchaseOrderRemoteDataSource {
  final ApiConsumer api;

  AddPurchaseOrderRemoteDataSource({required this.api});
  Future<PurchaseOrderModel> postAddPurchaseOrder(
      LanguageParam params, Map<String, dynamic> body) async {
    final response = await api.post(EndPoints.purchaseOrders,
        queryParameters: params.toMap(), data: body);
    return PurchaseOrderModel.fromJson(response);
  }
}
