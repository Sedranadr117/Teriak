import 'package:hive/hive.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/hive_product_item_model.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/product_item_model.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/purchase_model .dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/purchase_entity%20.dart';

part 'hive_purchase_order_model.g.dart';

@HiveType(typeId: 10)
class HivePurchaseOrderModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int supplierId;

  @HiveField(2)
  final String supplierName;

  @HiveField(3)
  final String currency;

  @HiveField(4)
  final double total;

  @HiveField(5)
  final String status;

  @HiveField(6)
  final List<int> createdAt;

  @HiveField(7)
  final List<HiveProductItemModel> items;

  HivePurchaseOrderModel({
    required this.id,
    required this.supplierId,
    required this.supplierName,
    required this.currency,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory HivePurchaseOrderModel.fromPurchaseOrderModel(
      PurchaseOrderModel model) {
    return HivePurchaseOrderModel(
      id: model.id,
      supplierId: model.supplierId,
      supplierName: model.supplierName,
      currency: model.currency,
      total: model.total,
      status: model.status,
      createdAt: model.createdAt,
      items: model.items
          .map((item) => HiveProductItemModel.fromProductItemModel(
              item as ProductItemModel))
          .toList(),
    );
  }

  PurchaseOrderEntity toEntity() {
    return PurchaseOrderEntity(
      id: id,
      supplierId: supplierId,
      supplierName: supplierName,
      currency: currency,
      total: total,
      status: status,
      createdAt: createdAt,
      items: items.map((item) => item.toEntity()).toList(),
    );
  }

  // Generate a unique key for caching (using id)
  String get cacheKey => id.toString();
}
