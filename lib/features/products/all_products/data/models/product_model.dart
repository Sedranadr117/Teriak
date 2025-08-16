import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/features/products/all_products/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.tradeName,
    required super.scientificName,
    required super.barcodes,
    required super.barcode,
    required super.productType,
    required super.requiresPrescription,
    required super.concentration,
    required super.size,
    required super.type,
    required super.form,
    required super.manufacturer,
    required super.notes,
    required super.categories,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json[ApiKeys.id],
      tradeName: json[ApiKeys.tradeName],
      scientificName: json[ApiKeys.scientificName],
      barcode:
          (json.containsKey(ApiKeys.barcode) && json[ApiKeys.barcode] != null)
              ? json[ApiKeys.barcode].toString()
              : " ",
      barcodes:
          (json.containsKey(ApiKeys.barcodes) && json[ApiKeys.barcodes] != null)
              ? (json[ApiKeys.barcodes]).map((e) => e.toString()).toList()
              : [],
      productType: json[ApiKeys.productType],
      requiresPrescription: json[ApiKeys.requiresPrescription],
      concentration: json.containsKey(ApiKeys.concentration) &&
              json[ApiKeys.concentration] != null
          ? json[ApiKeys.concentration]
          : '',
      size: json.containsKey(ApiKeys.size) && json[ApiKeys.size] != null
          ? json[ApiKeys.size]
          : '',
      type: json.containsKey(ApiKeys.type) && json[ApiKeys.type] != null
          ? json[ApiKeys.type]
          : '',
      form: json.containsKey(ApiKeys.form) && json[ApiKeys.form] != null
          ? json[ApiKeys.form]
          : '',
      manufacturer: json.containsKey(ApiKeys.manufacturer) &&
              json[ApiKeys.manufacturer] != null
          ? json[ApiKeys.manufacturer]
          : '',
      notes: json.containsKey(ApiKeys.notes) && json[ApiKeys.notes] != null
          ? json[ApiKeys.notes]
          : '',
      categories: (json.containsKey(ApiKeys.categories) &&
              json[ApiKeys.categories] != null)
          ? (json[ApiKeys.categories]).map((e) => e.toString()).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.tradeName: tradeName,
      ApiKeys.scientificName: scientificName,
      ApiKeys.barcode: barcode,
      ApiKeys.barcodes: barcodes,
      ApiKeys.productType: productType,
      ApiKeys.requiresPrescription: requiresPrescription,
      ApiKeys.concentration: concentration,
      ApiKeys.size: size,
      ApiKeys.type: type,
      ApiKeys.form: form,
      ApiKeys.manufacturer: manufacturer,
      ApiKeys.notes: notes,
      ApiKeys.categories: categories,
    };
  }
}
