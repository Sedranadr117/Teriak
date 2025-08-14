import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class DetailsSupplierRemoteDataSource {
  final ApiConsumer api;

  DetailsSupplierRemoteDataSource({required this.api});
  Future<SupplierModel> getDetailsSupplier(SupplierParams params) async {
    final response = await api.get("${EndPoints.suppliers}/${params.id}");
    return SupplierModel.fromJson(response);
  }
}
