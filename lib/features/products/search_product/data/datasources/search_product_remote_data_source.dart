import 'package:teriak/features/products/all_products/data/models/paginated_products_model.dart';
import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class SearchProductRemoteDataSource {
  final ApiConsumer api;

  SearchProductRemoteDataSource({required this.api});
  Future<PaginatedProductsModel> searchProduct(
      SearchProductParams params) async {
    final response = await api.get(
      EndPoints.searchProduct,
      queryParameters: params.toMap(),
    );
    return PaginatedProductsModel.fromJson(response);
  }
}
