import 'package:teriak/features/purchase/all_purchase_orders/domain/entities/product_item_entity.dart';

class PurchaseOrderEntity {
  final int id;
  final String supplierName;
  final String currency;
  final double total;
  final String status;
  final List<ProductItemEntity> items;

  const PurchaseOrderEntity({
    required this.id,
    required this.supplierName,
    required this.currency,
    required this.total,
    required this.status,
    required this.items,
  });
}
