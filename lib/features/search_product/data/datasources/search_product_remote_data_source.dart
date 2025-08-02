import 'package:teriak/features/master_product/data/models/product_model.dart';
import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class SearchProductRemoteDataSource {
  final ApiConsumer api;

  SearchProductRemoteDataSource({required this.api});
  Future<List<ProductModel>> searchProduct(SearchProductParams params) async {
    final response = await api.get(
      EndPoints.searchProduct,
      queryParameters: params.toMap(),
    );
    return (response as List)
        .map((item) => ProductModel.fromJson(item))
        .toList();
  }
}
