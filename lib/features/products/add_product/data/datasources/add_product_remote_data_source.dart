import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/features/products/all_products/data/models/product_model.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/params/params.dart';

class AddProductRemoteDataSource {
  final ApiConsumer api;

  AddProductRemoteDataSource({required this.api});
  Future<ProductModel> postAddProduct(
      AddProductParams params, Map<String, dynamic> body) async {
    final response = await api.post(
      EndPoints.pharmacyProduct,
      queryParameters: params.toMap(),
      data: body,
    );
    return ProductModel.fromJson(response);
  }
}
