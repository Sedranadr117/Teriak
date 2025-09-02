import 'package:teriak/features/settings/domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  UserProfileModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    super.position,
    required super.role,
    required super.additionalPermissions,
    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.updatedBy,
    required super.pharmacyId,
    required super.pharmacyName,
    required super.isAccountActive,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      position: json['position'] as String?,
      role: UserRoleModel.fromJson(json['role'] as Map<String, dynamic>),
      additionalPermissions: (json['additionalPermissions'] as List<dynamic>?)
              ?.map((e) =>
                  UserPermissionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? _parseDateTimeFromArray(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? _parseDateTimeFromArray(json['updatedAt'])
          : null,
      createdBy: json['createdBy'] as int?,
      updatedBy: json['updatedBy'] as int?,
      pharmacyId: json['pharmacyId'] as int,
      pharmacyName: json['pharmacyName'] as String,
      isAccountActive: json['isAccountActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'position': position,
      'role': (role as UserRoleModel).toJson(),
      'additionalPermissions': additionalPermissions
          .map((e) => (e as UserPermissionModel).toJson())
          .toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'pharmacyId': pharmacyId,
      'pharmacyName': pharmacyName,
      'isAccountActive': isAccountActive,
    };
  }

  /// Helper method to parse date arrays from API response
  /// API returns dates as arrays: [year, month, day, hour, minute, second, microsecond]
  static DateTime? _parseDateTimeFromArray(dynamic dateArray) {
    try {
      if (dateArray is List && dateArray.length >= 6) {
        // Extract year, month, day, hour, minute, second
        final year = dateArray[0] as int;
        final month = dateArray[1] as int;
        final day = dateArray[2] as int;
        final hour = dateArray[3] as int;
        final minute = dateArray[4] as int;
        final second = dateArray[5] as int;

        return DateTime(year, month, day, hour, minute, second);
      }
    } catch (e) {
      print('⚠️ Error parsing date array: $e');
    }
    return null;
  }
}

class UserRoleModel extends UserRoleEntity {
  UserRoleModel({
    required super.id,
    required super.name,
    required super.description,
    required super.permissions,
    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.updatedBy,
    required super.active,
    required super.system,
    required super.systemGenerated,
  });

  factory UserRoleModel.fromJson(Map<String, dynamic> json) {
    return UserRoleModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => UserPermissionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] != null
          ? UserProfileModel._parseDateTimeFromArray(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? UserProfileModel._parseDateTimeFromArray(json['updatedAt'])
          : null,
      createdBy: json['createdBy'] as int?,
      updatedBy: json['updatedBy'] as int?,
      active: json['active'] as bool,
      system: json['system'] as bool,
      systemGenerated: json['systemGenerated'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'permissions':
          permissions.map((e) => (e as UserPermissionModel).toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'active': active,
      'system': system,
      'systemGenerated': systemGenerated,
    };
  }
}

class UserPermissionModel extends UserPermissionEntity {
  UserPermissionModel({
    required super.id,
    required super.name,
    required super.description,
    required super.resource,
    required super.action,
    super.createdAt,
    super.updatedAt,
    super.createdBy,
    super.updatedBy,
    required super.active,
    required super.systemGenerated,
  });

  factory UserPermissionModel.fromJson(Map<String, dynamic> json) {
    return UserPermissionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      resource: json['resource'] as String,
      action: json['action'] as String,
      createdAt: json['createdAt'] != null
          ? UserProfileModel._parseDateTimeFromArray(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? UserProfileModel._parseDateTimeFromArray(json['updatedAt'])
          : null,
      createdBy: json['createdBy'] as int?,
      updatedBy: json['updatedBy'] as int?,
      active: json['active'] as bool,
      systemGenerated: json['systemGenerated'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'resource': resource,
      'action': action,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'active': active,
      'systemGenerated': systemGenerated,
    };
  }
}
