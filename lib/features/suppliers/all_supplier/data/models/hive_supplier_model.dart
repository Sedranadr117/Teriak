import 'package:hive/hive.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import 'package:teriak/features/suppliers/all_supplier/domain/entities/supplier_entity.dart';

part 'hive_supplier_model.g.dart';

@HiveType(typeId: 8)
class HiveSupplierModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final String address;

  @HiveField(4)
  final String preferredCurrency;

  HiveSupplierModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.preferredCurrency,
  });

  factory HiveSupplierModel.fromSupplierModel(SupplierModel model) {
    return HiveSupplierModel(
      id: model.id,
      name: model.name,
      phone: model.phone,
      address: model.address,
      preferredCurrency: model.preferredCurrency,
    );
  }

  SupplierEntity toEntity() {
    return SupplierEntity(
      id: id,
      name: name,
      phone: phone,
      address: address,
      preferredCurrency: preferredCurrency,
    );
  }

  // Generate a unique key for caching (using id)
  String get cacheKey => id.toString();
}

