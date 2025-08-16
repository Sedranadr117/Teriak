import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/data/models/paginated_invoice_model.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class SearchPurchaseInvoiceRemoteDataSource {
  final ApiConsumer api;

  SearchPurchaseInvoiceRemoteDataSource({required this.api});
  Future<PaginatedInvoiceModel> getSearchPurchaseInvoiceBySupplier(
      SearchBySupplierParams params) async {
    final response = await api.get(
        "${EndPoints.purchaseInvoicesSearchBySupplier}/${params.supplierId}");
    return PaginatedInvoiceModel.fromJson(response);
  }

  Future<PaginatedInvoiceModel> getSearchPurchaseInvoiceByDateRange(
      SearchByDateRangeParams params) async {
    final response = await api.get(EndPoints.purchaseInvoicesSearchByDateRange,
        queryParameters: params.toMap());
    return PaginatedInvoiceModel.fromJson(response);
  }
}
