import '../../domain/entities/auth_entitiy.dart';

class AuthModel extends AuthEntity {
  AuthModel({
    super.token,
    super.email,
    super.firstName,
    super.lastName,
    super.role,
    super.isAuthenticated,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: json['role'],
      isAuthenticated: json['token'] != null,
    );
  }

  @override
  // ignore: override_on_non_overriding_member
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
    };
  }
}
