import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';

class AllSupplierRemoteDataSource {
  final ApiConsumer api;

  AllSupplierRemoteDataSource({required this.api});
  Future<List<SupplierModel>> getAllSupplier() async {
    final response = await api.get(EndPoints.suppliers);
    print(response);
    return (response as List<dynamic>)
        .map((item) => SupplierModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
