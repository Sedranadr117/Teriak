import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/products/all_products/data/models/paginated_products_model.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';

class ProductRemoteDataSource {
  final ApiConsumer api;

  ProductRemoteDataSource({required this.api});
  Future<PaginatedProductsModel> getAllProduct(AllProductParams params) async {
    final response = await api.get(
      EndPoints.product,
      queryParameters: params.toMap(),
    );

    return PaginatedProductsModel.fromJson(response as Map<String, dynamic>);
  }
}
