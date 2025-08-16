import 'package:teriak/core/params/params.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  final ApiConsumer api;

  ProductRemoteDataSource({required this.api});
  Future<List<ProductModel>> getAllProduct(AllProductParams params) async {
       final response = await api.get(
      EndPoints.product, 
      queryParameters: params.toMap(), 
    );

      return (response as List<dynamic>)
      .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
      .toList();
  }
}
