import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class EditProductRemoteDataSource {
  final ApiConsumer api;

  EditProductRemoteDataSource({required this.api});
  Future<void> putEditProduct(
      EditProductParams params, Map<String, dynamic> body) async {
    await api.put(
      "${EndPoints.pharmacyProduct}/${params.id}",
      queryParameters: params.toMap(),
      data: body,
    );
  }
}
