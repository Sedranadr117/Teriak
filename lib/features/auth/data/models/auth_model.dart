import 'package:teriak/features/auth/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  AuthModel(
      {super.token,
      super.email,
      super.firstName,
      super.lastName,
      super.role,
      super.isActive});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
        token: json['token'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        role: json['role'],
        isActive: json['isActive']);
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'isActive': isActive
    };
  }
}
