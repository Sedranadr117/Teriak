import 'package:teriak/features/employee_management/domain/entities/role_id_entity.dart';

class RoleModel extends RoleEntity {
  const RoleModel({
    required super.id,
    required super.name,
    required super.description,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory RoleModel.fromEntity(RoleEntity entity) {
    return RoleModel(
        id: entity.id, name: entity.name, description: entity.description);
  }
}
