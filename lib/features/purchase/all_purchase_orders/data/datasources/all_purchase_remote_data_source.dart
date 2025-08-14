import 'package:teriak/features/purchase/all_purchase_orders/data/models/paginated_purchase_model.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class AllPurchaseOrdersRemoteDataSource {
  final ApiConsumer api;

  AllPurchaseOrdersRemoteDataSource({required this.api});
  Future<PaginatedPurchaseOrderModel> getAllPurchaseOrders(
      PaginationParams params) async {
    final response = await api.get(EndPoints.purchaseOrdersPaginated,
        queryParameters: params.toMap());
    return PaginatedPurchaseOrderModel.fromJson(
        response as Map<String, dynamic>);
  }
}
