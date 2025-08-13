import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/purchase_model .dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/paginated_purchase_entity.dart';

class PaginatedPurchaseOrderModel extends PaginatedPurchaseOrderEntity {
  const PaginatedPurchaseOrderModel({
    required super.content,
    required super.page,
    required super.size,
    required super.totalElements,
    required super.totalPages,
    required super.hasNext,
    required super.hasPrevious,
  });

  factory PaginatedPurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    return PaginatedPurchaseOrderModel(
      content: (json['content'] as List<dynamic>)
          .map((item) =>
              PurchaseOrderModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      page: json['page'],
      size: json['size'],
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
      hasNext: json['hasNext'],
      hasPrevious: json['hasPrevious'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content':
          content.map((e) => (e as PurchaseOrderModel).toJson()).toList(),
      'page': page,
      'size': size,
      'totalElements': totalElements,
      'totalPages': totalPages,
      'hasNext': hasNext,
      'hasPrevious': hasPrevious,
    };
  }
}
