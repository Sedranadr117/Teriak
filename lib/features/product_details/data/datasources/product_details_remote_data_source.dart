import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/features/master_product/data/models/product_model.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class ProductDetailsRemoteDataSource {
  final ApiConsumer api;

  ProductDetailsRemoteDataSource({required this.api});
  Future<ProductModel> getProductDetails(ProductDetailsParams params) async {
    final endpoint = (params.type == "Pharmacy" || params.type == "صيدلية")
        ? "${EndPoints.pharmacyProduct}/${params.id}"
        : "${EndPoints.masterProductDetails}/${params.id}";

    final response = await api.get(endpoint, queryParameters: params.toMap());
    return ProductModel.fromJson(response);
  }
}
