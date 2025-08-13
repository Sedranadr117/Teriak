// lib/features/purchase_invoices/domain/entities/purchase_invoice_entity.dart
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/entities/purchase_invoice_entity.dart';


class PaginatedInvoiceEntity {
  final List<PurchaseInvoiceEntity> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  PaginatedInvoiceEntity({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });


}
