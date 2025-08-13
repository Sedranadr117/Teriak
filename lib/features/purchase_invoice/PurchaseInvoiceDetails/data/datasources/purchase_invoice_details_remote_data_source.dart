import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/data/models/purchase_invoice_model.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class PurchaseInvoiceDetailsRemoteDataSource {
  final ApiConsumer api;

  PurchaseInvoiceDetailsRemoteDataSource({required this.api});
  Future<PurchaseInvoiceModel> getPurchaseInvoiceDetails(
      PurchaseInvoiceDetailsParams params) async {
    final response =
        await api.get("${EndPoints.purchaseInvoices}/${params.id}");
    return PurchaseInvoiceModel.fromJson(response);
  }
}
