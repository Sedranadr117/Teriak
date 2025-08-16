import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/core/databases/api/api_consumer.dart';
import 'package:teriak/features/products/product_data/data/models/product_data_model.dart';

class ProductDataRemoteDataSource {
  final ApiConsumer api;

  ProductDataRemoteDataSource({required this.api});

  Future<List<ProductDataModel>> getProductData(
      ProductDataParams params) async {
    late String endpoint;
    switch (params.type) {
      case 'forms':
        endpoint = EndPoints.form;
        break;
      case 'types':
        endpoint = EndPoints.type;
        break;
      case 'manufacturers':
        endpoint = EndPoints.manufacturers;
        break;
      case 'categories':
        endpoint = EndPoints.categories;
        break;
      default:
        throw Exception('Unknown product data type: ${params.type}');
    }

    final response = await api.get(endpoint, queryParameters: params.toMap());

    return ProductDataModel.fromJson(response as List<dynamic>);
  }
}
