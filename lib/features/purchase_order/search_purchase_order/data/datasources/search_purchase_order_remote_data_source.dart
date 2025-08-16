import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/paginated_purchase_model.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class SearchPurchaseOrderRemoteDataSource {
  final ApiConsumer api;

  SearchPurchaseOrderRemoteDataSource({required this.api});

  Future<PaginatedPurchaseOrderModel> getSearchPurchaseOrderBySupplier(
      SearchBySupplierParams params) async {
    final response = await api.get(
        "${EndPoints.purchaseOrderSearchBySupplier}/${params.supplierId}",
        queryParameters: params.toMap());
    return PaginatedPurchaseOrderModel.fromJson(response);
  }

  Future<PaginatedPurchaseOrderModel> getSearchPurchaseOrderByDateRange(
      SearchByDateRangeParams params) async {
    final response = await api.get(EndPoints.purchaseOrderSearchByDateRange,
        queryParameters: params.toMap());
    return PaginatedPurchaseOrderModel.fromJson(response);
  }
}
