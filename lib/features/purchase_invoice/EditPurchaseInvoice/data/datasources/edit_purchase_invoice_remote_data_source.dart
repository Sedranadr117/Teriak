import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/data/models/purchase_invoice_model.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class EditPurchaseInvoiceRemoteDataSource {
  final ApiConsumer api;

  EditPurchaseInvoiceRemoteDataSource({required this.api});
  Future<PurchaseInvoiceModel> putEditPurchaseInvoice(
      EditPurchaseInvoiceParams params,Map<String,dynamic> body) async {
    final response = await api.put(EndPoints.purchaseInvoices,queryParameters: params.toMap(),data:body);
    return PurchaseInvoiceModel.fromJson(response);
  }
}
