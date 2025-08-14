import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class EditSupplierRemoteDataSource {
  final ApiConsumer api;

  EditSupplierRemoteDataSource({required this.api});
  Future<SupplierModel> putEditSupplier(
      SupplierParams params, Map<String, dynamic> body) async {
    final response =
        await api.put("${EndPoints.suppliers}/${params.id}", data: body);
    return SupplierModel.fromJson(response);
  }
}
