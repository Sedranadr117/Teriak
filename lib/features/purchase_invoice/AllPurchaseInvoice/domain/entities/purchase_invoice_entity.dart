// lib/features/purchase_invoices/domain/entities/purchase_invoice_entity.dart
import 'purchase_invoice_item_entity.dart';

class PurchaseInvoiceEntity {
  final int id;
  final int purchaseOrderId;
  final String supplierName;
  final String currency;
  final double total;
  final String? invoiceNumber;
  final List<int> createdAt;
  final int createdBy;
  final List<PurchaseInvoiceItemEntity> items;

  PurchaseInvoiceEntity({
    required this.id,
    required this.purchaseOrderId,
    required this.supplierName,
    required this.currency,
    required this.total,
    this.invoiceNumber,
    required this.createdAt,
    required this.createdBy,
    required this.items,
  });
}
