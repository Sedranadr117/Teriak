import 'package:teriak/features/products/all_products/data/models/product_model.dart';
import 'package:teriak/features/products/all_products/domain/entities/paginated_products_entity.dart';

class PaginatedProductsModel extends PaginatedProductsEntity {
  PaginatedProductsModel({
    required super.content,
    required super.page,
    required super.size,
    required super.totalElements,
    required super.totalPages,
    required super.hasNext,
    required super.hasPrevious,
  });

  factory PaginatedProductsModel.fromJson(Map<String, dynamic> json) {
    return PaginatedProductsModel(
      content: (json['content'] as List<dynamic>?)
              ?.map((item) => ProductModel.fromJson(item))
              .toList() ??
          [],
      page: json['page'] ?? 0,
      size: json['size'] ?? 10,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNext: json['hasNext'] ?? false,
      hasPrevious: json['hasPrevious'] ?? false,
    );
  }
}
