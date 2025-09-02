import 'package:teriak/core/databases/api/api_consumer.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/features/settings/data/models/user_profile_model.dart';

class UserProfileRemoteDataSource {
  final ApiConsumer api;

  UserProfileRemoteDataSource({required this.api});

  Future<UserProfileModel> getUserProfile() async {
    try {
      print('🌐 Fetching user profile from: ${EndPoints.getUserProfile}');

      final response = await api.get(EndPoints.getUserProfile);

      print('📥 User profile response: $response');
      print('🔍 Response type: ${response.runtimeType}');

      if (response is Map<String, dynamic>) {
        print('🔍 Response keys: ${response.keys.toList()}');
        if (response['role'] != null) {
          print('🔍 Role data: ${response['role']}');
          print('🔍 Role type: ${response['role'].runtimeType}');
        }
        if (response['firstName'] != null) {
          print('🔍 First name: ${response['firstName']}');
        }
        if (response['lastName'] != null) {
          print('🔍 Last name: ${response['lastName']}');
        }
      }

      return UserProfileModel.fromJson(response);
    } catch (e) {
      print('❌ Error fetching user profile: $e');
      print('🔍 Error type: ${e.runtimeType}');
      rethrow;
    }
  }
}
