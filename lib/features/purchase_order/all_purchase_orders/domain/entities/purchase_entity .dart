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

  
  DateTime get creationDateTime {
    if (createdAt.length >= 6) {
      return DateTime(
        createdAt[0],
        createdAt[1],
        createdAt[2],
        createdAt[3],
        createdAt[4],
        createdAt[5],
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
