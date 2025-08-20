import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/product_item_entity.dart';

class PurchaseOrderEntity {
  final int id;
  final int supplierId;
  final String supplierName;
  final String currency;
  final double total;
  final String status;
  final List<int> createdAt;
  final List<ProductItemEntity> items;

  const PurchaseOrderEntity({
    required this.id,
    required this.supplierId,
    required this.supplierName,
    required this.currency,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.items,
  });
}
