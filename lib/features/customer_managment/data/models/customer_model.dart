import 'package:teriak/features/customer_managment/domain/entities/customer_entity.dart';

class CustomerModel extends CustomerEntity {
  CustomerModel({
    required int id,
    required String name,
    required String? phoneNumber,
    required String? address,
    String? notes,
  }) : super(
          id: id,
          name: name,
          phoneNumber: phoneNumber ?? '',
          address: address ?? '',
          notes: notes ?? '',
        );

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      notes: json['notes'],
    );
  }

  factory CustomerModel.fromEntity(CustomerEntity entity) {
    return CustomerModel(
      id: entity.id,
      name: entity.name,
      phoneNumber: entity.phoneNumber,
      address: entity.address,
      notes: entity.notes,
    );
  }
}
