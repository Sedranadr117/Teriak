import 'package:teriak/core/params/params.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';

class DeleteProductRemoteDataSource {
  final ApiConsumer api;

  DeleteProductRemoteDataSource({required this.api});
  Future<void> deleteProduct(DeleteProductParams params) async {
    await api.delete("${EndPoints.pharmacyProduct}/${params.id}");
  }
}
