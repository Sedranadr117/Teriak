import 'package:teriak/core/params/params.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';

class DeleteSupplierRemoteDataSource {
  final ApiConsumer api;

  DeleteSupplierRemoteDataSource({required this.api});
  Future<void> deleteSupplier(SupplierParams params) async {
    final response = await api.delete("${EndPoints.suppliers}/${params.id}");
  }
}
