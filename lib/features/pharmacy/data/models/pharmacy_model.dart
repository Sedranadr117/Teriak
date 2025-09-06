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
    super.areaId,
    super.areaName,
    super.areaArabicName,
    super.isActive,
    super.newPassword,
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
      areaId: json['areaId'],
      areaName: json['areaName'],
      areaArabicName: json['areaArabicName'],
      isActive: json['isActive'] ?? true,
      newPassword: '', // أو null حسب الاستخدام
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
      'areaId': areaId,
      'areaName': areaName,
      'areaArabicName': areaArabicName,
      'isActive': isActive,
      'newPassword': newPassword ?? '',
    };
  }
}
