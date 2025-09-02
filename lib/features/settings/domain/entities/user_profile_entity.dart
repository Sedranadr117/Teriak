class UserProfileEntity {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String? position;
  final UserRoleEntity role;
  final List<UserPermissionEntity> additionalPermissions;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? createdBy;
  final int? updatedBy;
  final int pharmacyId;
  final String pharmacyName;
  final bool isAccountActive;

  UserProfileEntity({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.position,
    required this.role,
    required this.additionalPermissions,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    required this.pharmacyId,
    required this.pharmacyName,
    required this.isAccountActive,
  });

  // Computed properties
  String get fullName => '$firstName $lastName'.trim();
  String get displayName => fullName.isNotEmpty ? fullName : 'Unknown User';
  String get roleName => role.name;
  String get roleDescription => role.description;
  bool get isActive => isAccountActive;
}

class UserRoleEntity {
  final int id;
  final String name;
  final String description;
  final List<UserPermissionEntity> permissions;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? createdBy;
  final int? updatedBy;
  final bool active;
  final bool system;
  final bool systemGenerated;

  UserRoleEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    required this.active,
    required this.system,
    required this.systemGenerated,
  });
}

class UserPermissionEntity {
  final int id;
  final String name;
  final String description;
  final String resource;
  final String action;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? createdBy;
  final int? updatedBy;
  final bool active;
  final bool systemGenerated;

  UserPermissionEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.resource,
    required this.action,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    required this.active,
    required this.systemGenerated,
  });
}
