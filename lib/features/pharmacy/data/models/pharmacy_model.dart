import 'package:teriak/features/pharmacy/domain/entities/pharmacy_entity.dart';

class PharmacyModel extends PharmacyEntity {
  PharmacyModel({
    super.id,
    required super.pharmacyName,
    required super.licenseNumber,
    required super.address,
    required super.email,
    required super.type,
    required super.openingHours,
    required super.phoneNumber,
    required super.managerEmail,
    required super.managerFirstName,
    required super.managerLastName,
    required super.newPassword,
  });

  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    return PharmacyModel(
      id: json['id'],
      pharmacyName: json['pharmacyName'],
      licenseNumber: json['licenseNumber'],
      address: json['address'],
      email: json['email'],
      type: json['type'],
      openingHours: json['openingHours'],
      phoneNumber: json['phoneNumber'],
      managerEmail: json['managerEmail'],
      managerFirstName: json['managerFirstName'],
      managerLastName: json['managerLastName'],
      newPassword: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pharmacyName': pharmacyName,
      'licenseNumber': licenseNumber,
      'address': address,
      'email': email,
      'type': type,
      'openingHours': openingHours,
      'phoneNumber': phoneNumber,
      'managerEmail': managerEmail,
      'managerFirstName': managerFirstName,
      'managerLastName': managerLastName,
      'newPassword': newPassword,
    };
  }
}
