import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/product_item_model.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/purchase_entity%20.dart';

class PurchaseOrderModel extends PurchaseOrderEntity {
  const PurchaseOrderModel({
    required super.id,
    required super.supplierId,
    required super.supplierName,
    required super.currency,
    required super.total,
    required super.status,
    required super.createdAt,
    required super.items,
  });

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderModel(
      id: json[ApiKeys.id],
      supplierId: json[ApiKeys.supplierId],
      supplierName: json[ApiKeys.supplierName],
      currency: json[ApiKeys.currency],
      total: (json[ApiKeys.total] as num).toDouble(),
      status: json[ApiKeys.status],
      createdAt:List<int>.from(json[ApiKeys.createdAt] ?? []),
      items: (json[ApiKeys.items] as List<dynamic>)
          .map(
              (item) => ProductItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.supplierId: supplierId,
      ApiKeys.supplierName: supplierName,
      ApiKeys.currency: currency,
      ApiKeys.total: total,
      ApiKeys.status: status,
       ApiKeys.createdAt:createdAt,
      ApiKeys.items:
          items.map((e) => (e as ProductItemModel).toJson()).toList(),
    };
  }

      DateTime get creationDateTime {
    if (createdAt.length >= 6) {
      return DateTime(
        createdAt[0], // year
        createdAt[1], // month
        createdAt[2], // day
        createdAt[3], // hour
        createdAt[4], // minute
        createdAt[5], // second
      );
    }
    return DateTime.now();
  }

  String get formattedCreationDateTime {
    final date = creationDateTime;
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    final formattedTime =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    return '$formattedDate, $formattedTime';
  }
}
