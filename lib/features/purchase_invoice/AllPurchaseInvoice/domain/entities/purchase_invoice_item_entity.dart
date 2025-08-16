// lib/features/purchase_invoices/domain/entities/purchase_invoice_item_entity.dart
class PurchaseInvoiceItemEntity {
  final int id;
  final String productName;
  final int receivedQty;
  final int bonusQty;
  final double invoicePrice;
  final double actualPrice;
  final String batchNo;
  final List<int> expiryDate;

  PurchaseInvoiceItemEntity({
    required this.id,
    required this.productName,
    required this.receivedQty,
    required this.bonusQty,
    required this.invoicePrice,
    required this.actualPrice,
    required this.batchNo,
    required this.expiryDate,
  });
}
