import 'package:teriak/features/auth/data/models/auth_model.dart';

import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';
import '../../../../../core/params/params.dart';

class AuthRemoteDataSource {
  final ApiConsumer api;

  AuthRemoteDataSource({required this.api});

  Future<AuthModel> getAuth(AuthParams params) async {
    switch (params.authType) {
      case AuthType.adminLogin:
        return await _adminLogin(params);
      case AuthType.logout:
        return await _logout();
      // ignore: unreachable_switch_default
      default:
        throw Exception('Invalid auth type: ${params.authType}');
    }
  }

  Future<AuthModel> _adminLogin(AuthParams params) async {
    print('🌐 Sending login request to: ${EndPoints.adminLogin}');
    print('📤 Email: ${params.email}, Password: ${params.password}');

    final response = await api.post(
      EndPoints.adminLogin,
      data: {
        'email': params.email,
        'password': params.password,
      },
    );

    print('📥 Response received: $response');
    return AuthModel.fromJson(response);
  }

  Future<AuthModel> _logout() async {
    final response = await api.post(EndPoints.logout);
    return AuthModel.fromJson(response);
  }
}
