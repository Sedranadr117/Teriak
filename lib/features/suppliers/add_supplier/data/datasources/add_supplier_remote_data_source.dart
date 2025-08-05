import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';


class AddSupplierRemoteDataSource {
  final ApiConsumer api;

  AddSupplierRemoteDataSource({required this.api});
  Future<SupplierModel> postAddSupplier(Map<String, dynamic> body) async {
    final response = await api.post(EndPoints.suppliers,data: body);
    return SupplierModel.fromJson(response);
  }
}
