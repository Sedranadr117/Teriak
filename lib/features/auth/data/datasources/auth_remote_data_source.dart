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
    }
  }

  Future<AuthModel> _adminLogin(AuthParams params) async {
    final response = await api.post(
      EndPoints.adminLogin,
      data: {
        'email': params.email,
        'password': params.password,
      },
    );
    return AuthModel.fromJson(response);
  }

  Future<AuthModel> _logout() async {
    final response = await api.post(EndPoints.logout);
    return AuthModel.fromJson(response);
  }
}
