import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/features/suppliers/all_supplier/domain/entities/supplier_entity.dart';

class SupplierModel extends SupplierEntity {
  SupplierModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.address,
    required super.preferredCurrency,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json[ApiKeys.id],
      name: json[ApiKeys.name],
      phone: json[ApiKeys.phone],
      address: json[ApiKeys.address],
      preferredCurrency: json[ApiKeys.preferredCurrency],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.name: name,
      ApiKeys.phone: phone,
      ApiKeys.address: address,
      ApiKeys.preferredCurrency: preferredCurrency,
    };
  }
}
