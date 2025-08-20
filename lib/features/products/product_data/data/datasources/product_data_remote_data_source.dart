import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/core/databases/api/api_consumer.dart';
import 'package:teriak/features/products/product_data/data/models/product_data_model.dart';
import 'package:teriak/features/products/product_data/data/models/product_names_model.dart';

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

  Future<ProductNamesModel> getProductNames(ProductNamesParams params) async {
    late String endpoint;

    // إصلاح switch statement
    if (params.type == "Master" || params.type == "مركزي") {
      endpoint = EndPoints.masterProductNames;
    } else if (params.type == "Pharmacy" || params.type == "صيدلية") {
      endpoint = EndPoints.pharmacyProductNames;
    } else {
      throw Exception('Unknown product data type: ${params.type}');
    }

    final response = await api.get("$endpoint/${params.id}");
    print("🟢 RAW RESPONSE: ${response.data}");
    print("Product Type: ${params.type}");
    print("Endpoint: $endpoint");
    print("Product ID: ${params.id}");
    print("Response Status: ${response.statusCode}");

    return ProductNamesModel.fromJson(response.data);
  }
}
