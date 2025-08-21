import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/features/stock_management/data/models/Stock_model.dart';
import 'package:teriak/features/stock_management/data/models/stock_item_model.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/params/params.dart';

class StockRemoteDataSource {
  final ApiConsumer api;

  StockRemoteDataSource({required this.api});
  Future<List<StockModel>> getStock() async {
    final response = await api.get(EndPoints.getStock);
    final List data = response;
    return data
        .map((json) => StockModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<StockModel>> searchStock(SearchStockParams params) async {
    final response = await api.get(
      EndPoints.searchStock,
      queryParameters: params.toMap(),
    );
    print('Query params: ${params.toMap()}');

    print(response);
    return (response as List).map((item) => StockModel.fromJson(item)).toList();
  }

  Future<StockModel> editStock(int stockItemId, StockParams params) async {
    try {
      final stockData = {
        "quantity": params.quantity,
        "expiryDate": params.expiryDate,
        "minStockLevel": params.minStockLevel,
        "reasonCode": params.reasonCode,
        "additionalNotes": params.additionalNotes,
      };

      print('📤 Sending stock data: $stockData');

      final response = await api.put(
        'stock/$stockItemId/edit',
        data: stockData,
      );
      return StockModel.fromJson(response);
    } catch (e) {
      print('❌ Error in stock  : $e');
      rethrow;
    }
  }

  Future<void> deleteStock(int id) async {
    try {
      final response = await api.delete('stock/$id');
      print(response);
    } catch (e) {
      print('❌ Error in deleting : $e');
      rethrow;
    }
  }

  Future<StockDetailsModel> getDetailsStock({
    required int productId,
    required String productType,
  }) async {
    final response = await api.get(
      '${EndPoints.getDetailsStock}/$productId/details',
      queryParameters: {
        'productType': productType,
      },
    );
    print(response);
    return StockDetailsModel.fromJson(response);
  }
}
