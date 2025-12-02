import 'package:hive/hive.dart';
import 'package:teriak/features/products/product_data/data/models/product_names_model.dart';
import 'package:teriak/features/products/product_data/domain/entities/product_names_entity.dart';

part 'hive_product_names_model.g.dart';

@HiveType(typeId: 7)
class HiveProductNamesModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String tradeNameAr;

  @HiveField(2)
  final String tradeNameEn;

  @HiveField(3)
  final String scientificNameAr;

  @HiveField(4)
  final String scientificNameEn;

  HiveProductNamesModel({
    required this.id,
    required this.tradeNameAr,
    required this.tradeNameEn,
    required this.scientificNameAr,
    required this.scientificNameEn,
  });

  factory HiveProductNamesModel.fromProductNamesModel(ProductNamesModel model) {
    return HiveProductNamesModel(
      id: model.id,
      tradeNameAr: model.tradeNameAr,
      tradeNameEn: model.tradeNameEn,
      scientificNameAr: model.scientificNameAr,
      scientificNameEn: model.scientificNameEn,
    );
  }

  ProductNamesEntity toEntity() {
    return ProductNamesEntity(
      id: id,
      tradeNameAr: tradeNameAr,
      tradeNameEn: tradeNameEn,
      scientificNameAr: scientificNameAr,
      scientificNameEn: scientificNameEn,
    );
  }
}

