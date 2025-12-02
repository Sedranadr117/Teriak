import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/purchase_model%20.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class AddPurchaseOrderRemoteDataSource {
  final ApiConsumer api;

  AddPurchaseOrderRemoteDataSource({required this.api});
  Future<PurchaseOrderModel> postAddPurchaseOrder(
      LanguageParam params, Map<String, dynamic> body) async {
    print('🌐 POST ${EndPoints.purchaseOrders}');
    print('📤 Query params: ${params.toMap()}');
    print('📤 Body: $body');
    
    try {
      final response = await api.post(EndPoints.purchaseOrders,
          queryParameters: params.toMap(), data: body);
      print('✅ Server response received: $response');
      return PurchaseOrderModel.fromJson(response);
    } catch (e, stackTrace) {
      print('❌ Error in postAddPurchaseOrder: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }
}
