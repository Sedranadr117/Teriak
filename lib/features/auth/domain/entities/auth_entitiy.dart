class AuthEntity {
  final String? token;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? role;
  final bool isAuthenticated;

  AuthEntity({
    this.token,
    this.email,
    this.firstName,
    this.lastName,
    this.role,
    this.isAuthenticated = false,
  });
}
