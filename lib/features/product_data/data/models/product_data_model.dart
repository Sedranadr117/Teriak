import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/features/product_data/domain/entities/product_data_entity.dart';

class ProductDataModel extends ProductDataEntity {
  ProductDataModel({
    required super.id,
    required super.name,
  });
  static List<ProductDataModel> fromJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) =>
            ProductDataModel.fromJsonIndex(json as Map<String, dynamic>))
        .toList();
  }

  factory ProductDataModel.fromJsonIndex(Map<String, dynamic> json) {
    return ProductDataModel(
      id: json[ApiKeys.id] as int,
      name: json[ApiKeys.name] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.name: name,
    };
  }
}
