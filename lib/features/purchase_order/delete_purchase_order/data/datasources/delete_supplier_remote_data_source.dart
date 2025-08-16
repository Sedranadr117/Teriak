import 'package:teriak/core/params/params.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';

class DeletePurchaseOrderRemoteDataSource {
  final ApiConsumer api;

  DeletePurchaseOrderRemoteDataSource({required this.api});
  Future<void> deletePurchaseOrder(
      DeletePurchaseOrderParams params) async {
    final response = await api.delete("${EndPoints.purchaseOrders}/${params.id}");
  }
}
