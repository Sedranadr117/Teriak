import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/purchase_model%20.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class EditPurchaseOrdersRemoteDataSource {
  final ApiConsumer api;

  EditPurchaseOrdersRemoteDataSource({required this.api});
  Future<PurchaseOrderModel> putEditPurchaseOrders(
      EditPurchaseOrdersParams params, Map<String, dynamic> body) async {
    final response = await api.put("${EndPoints.purchaseOrders}/${params.id}",
        queryParameters: params.toMap(), data: body);
    return PurchaseOrderModel.fromJson(response);
  }
}
