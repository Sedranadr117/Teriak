class AuthEntity {
  final String? token;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? role;

  AuthEntity({
    this.token,
    this.email,
    this.firstName,
    this.lastName,
    this.role,
  });

  bool get isAuthenticated => token != null && token!.isNotEmpty;
}
