import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/features/purchase/all_purchase_orders/data/models/product_item_model.dart';
import 'package:teriak/features/purchase/all_purchase_orders/domain/entities/purchase_entity%20.dart';

class PurchaseOrderModel extends PurchaseOrderEntity {
  const PurchaseOrderModel({
    required super.id,
    required super.supplierName,
    required super.currency,
    required super.total,
    required super.status,
    required super.items,
  });

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderModel(
      id: json[ApiKeys.id],
      supplierName: json[ApiKeys.supplierName],
      currency: json[ApiKeys.currency],
      total: (json[ApiKeys.total] as num).toDouble(),
      status: json[ApiKeys.status],
      items: (json[ApiKeys.items] as List<dynamic>)
          .map((item) => ProductItemModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.supplierName: supplierName,
      ApiKeys.currency: currency,
      ApiKeys.total: total,
      ApiKeys.status: status,
      ApiKeys.items: items.map((e) => (e as ProductItemModel).toJson()).toList(),
    };
  }
}
