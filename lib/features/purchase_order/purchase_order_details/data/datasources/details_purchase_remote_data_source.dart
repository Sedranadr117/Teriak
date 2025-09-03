import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/purchase_model%20.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class DetailsPurchaseOrdersRemoteDataSource {
  final ApiConsumer api;

  DetailsPurchaseOrdersRemoteDataSource({required this.api});
  Future<PurchaseOrderModel> getDetailsPurchaseOrders(
      DetailsPurchaseOrdersParams params) async {
    final response = await api.get("${EndPoints.purchaseOrders}/${params.id}",
        queryParameters: params.toMap());
    return PurchaseOrderModel.fromJson(response);
  }
}
