import 'package:teriak/features/pharmacy/domain/entities/area_entity.dart';

class AreaModel extends AreaEntity {
  AreaModel({
    required super.id,
    required super.name,
    required super.localizedName,
    required super.description,
    required super.isActive,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['id'],
      name: json['name'],
      localizedName: json['localizedName'],
      description: json['description'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'localizedName': localizedName,
      'description': description,
      'isActive': isActive,
    };
  }
}
