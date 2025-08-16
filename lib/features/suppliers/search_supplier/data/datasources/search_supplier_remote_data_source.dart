import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class SearchSupplierRemoteDataSource {
  final ApiConsumer api;

  SearchSupplierRemoteDataSource({required this.api});
  Future<List<SupplierModel>> searchSupplier(SearchSupplierParams params) async {
    final response = await api.get(
      EndPoints.searchSuppliers,
      queryParameters: params.toMap(),
    );
    return (response as List)
        .map((item) => SupplierModel.fromJson(item))
        .toList();
  }
}
