class RefundItemEntity {
  final int itemId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final String itemRefundReason;

  RefundItemEntity({
    required this.itemId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    required this.itemRefundReason,
  });
}

class SaleRefundEntity {
  final String refundStatus;
  final int refundId;
  final int saleInvoiceId;
  final double totalRefundAmount;
  final String refundReason;
  final DateTime refundDate;
  final List<RefundItemEntity> refundedItems;
  final bool stockRestored;

  // الحقول الجديدة
  final int customerId;
  final String customerName;
  final double originalInvoiceAmount;
  final double originalInvoicePaidAmount;
  final double originalInvoiceRemainingAmount;
  final String paymentType;
  final String paymentMethod;
  final String currency;
  final double customerTotalDebt;
  final int customerActiveDebtsCount;

  SaleRefundEntity({
    required this.refundStatus,
    required this.refundId,
    required this.saleInvoiceId,
    required this.totalRefundAmount,
    required this.refundReason,
    required this.refundDate,
    required this.refundedItems,
    required this.stockRestored,
    required this.customerId,
    required this.customerName,
    required this.originalInvoiceAmount,
    required this.originalInvoicePaidAmount,
    required this.originalInvoiceRemainingAmount,
    required this.paymentType,
    required this.paymentMethod,
    required this.currency,
    required this.customerTotalDebt,
    required this.customerActiveDebtsCount,
  });
}
