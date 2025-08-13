import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/data/models/paginated_invoice_model.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class AllPurchaseInvoiceRemoteDataSource {
  final ApiConsumer api;

  AllPurchaseInvoiceRemoteDataSource({required this.api});
  Future<PaginatedInvoiceModel> getAllPurchaseInvoice(
      PaginationParams params) async {
    final response = await api.get(EndPoints.purchaseInvoicesPaginated,queryParameters: params.toMap());
    return PaginatedInvoiceModel.fromJson(response as Map<String, dynamic>);
  }
}
