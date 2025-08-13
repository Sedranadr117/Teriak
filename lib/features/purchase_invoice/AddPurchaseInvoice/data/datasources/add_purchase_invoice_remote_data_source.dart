
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/data/models/purchase_invoice_model.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class  AddPurchaseInvoiceRemoteDataSource {
  final ApiConsumer api;

   AddPurchaseInvoiceRemoteDataSource({required this.api});
  Future<PurchaseInvoiceModel>postAddPurchaseInvoice( LanguageParam params,Map<String,dynamic> body) async {
    final response = await api.post(EndPoints.purchaseInvoices,queryParameters: params.toMap(),data:body);
    return PurchaseInvoiceModel.fromJson(response);
  }
}
