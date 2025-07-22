import 'package:teriak/core/databases/api/api_consumer.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/pharmacy/data/models/pharmacy_model.dart';

class PharmacyRemoteDataSource {
  final ApiConsumer api;

  PharmacyRemoteDataSource({required this.api});

  Future<PharmacyModel> addPharmacy(PhaParams params) async {
    final data = <String, dynamic>{};
    data['location'] = params.location ?? '';
    data['pharmacyEmail'] = params.pharmacyEmail ?? '';
    data['openingHours'] = params.openingHours ?? '';
    data['pharmacyPhone'] = params.pharmacyPhone ?? '';
    data['managerFirstName'] = params.managerFirstName ?? '';
    data['managerLastName'] = params.managerLastName ?? '';
    data['newPassword'] = params.newPassword ?? '';

    print('🔍 Sending pharmacy data: $data');

    final response = await api.post(
      EndPoints.addPharmacy,
      queryParameters: data,
    );
    return PharmacyModel.fromJson(response);
  }

  // @override
  // Future<List<PharmacyModel>> getAllPharmacies() async {
  //   final response = await api.get(EndPoints.getAllPharmacies);
  //   return (response as List)
  //       .map((json) => PharmacyModel.fromJson(json))
  //       .toList();
  // }

  // @override
  // Future<PharmacyModel> getPharmacyById(String id) async {
  //   final response = await api.get('${EndPoints.getPharmacyById}/$id');
  //   return PharmacyModel.fromJson(response);
  // }

  // @override
  // Future<bool> deletePharmacy(String id) async {
  //   // await api.delete('${EndPoints.deletePharmacy}/$id');
  //   return true;
  // }

  Future<List<PharmacyModel>> getAllPharmacies() {
    // TODO: implement getAllPharmacies
    throw UnimplementedError();
  }

  // @override
  // Future<PharmacyModel> getPharmacyById(String id) {
  //   // TODO: implement getPharmacyById
  //   throw UnimplementedError();
  // }
}
