import 'package:hive/hive.dart';
import 'package:teriak/features/products/product_data/data/models/product_data_model.dart';
import 'package:teriak/features/products/product_data/domain/entities/product_data_entity.dart';

part 'hive_product_data_model.g.dart';

@HiveType(typeId: 6)
class HiveProductDataModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  HiveProductDataModel({
    required this.id,
    required this.name,
  });

  factory HiveProductDataModel.fromProductDataModel(ProductDataModel model) {
    return HiveProductDataModel(
      id: model.id,
      name: model.name,
    );
  }

  ProductDataEntity toEntity() {
    return ProductDataEntity(
      id: id,
      name: name,
    );
  }
}

