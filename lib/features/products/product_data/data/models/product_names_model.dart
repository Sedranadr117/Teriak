import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/features/products/product_data/domain/entities/product_names_entity.dart';

class ProductNamesModel extends ProductNamesEntity {
  const ProductNamesModel({
    required super.id,
    required super.tradeNameAr,
    required super.tradeNameEn,
    required super.scientificNameAr,
    required super.scientificNameEn,
  });

  factory ProductNamesModel.fromJson(Map<String, dynamic> json) {

    return ProductNamesModel(
      id: json[ApiKeys.id] ?? 0,
      tradeNameAr: json[ApiKeys.tradeNameAr],
      tradeNameEn: json[ApiKeys.tradeNameEn],
      scientificNameAr: json[ApiKeys.scientificNameAr],
      scientificNameEn: json[ApiKeys.scientificNameEn],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.tradeNameAr: tradeNameAr,
      ApiKeys.tradeNameEn: tradeNameEn,
      ApiKeys.scientificNameAr: scientificNameAr,
      ApiKeys.scientificNameEn: scientificNameEn,
    };
  }
}
