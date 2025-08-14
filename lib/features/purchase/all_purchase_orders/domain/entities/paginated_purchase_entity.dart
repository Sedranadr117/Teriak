import 'package:teriak/features/purchase/all_purchase_orders/domain/entities/purchase_entity .dart';

class PaginatedPurchaseOrderEntity {
  final List<PurchaseOrderEntity> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const PaginatedPurchaseOrderEntity({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });
}
