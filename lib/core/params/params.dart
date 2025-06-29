class TemplateParams {
  final String id;
  TemplateParams({required this.id});
}

class AuthParams {
  final String? id;
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? role;
  final AuthType authType;

  AuthParams({
    this.id,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.role,
    required this.authType,
  });
}

enum AuthType {
  adminLogin,
  logout,
}
