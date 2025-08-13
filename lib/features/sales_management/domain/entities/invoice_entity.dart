class InvoiceEntity {
  final int id;
  final int customerId;
  final String customerName;
  final String invoiceDate;
  final double totalAmount;
  final String paymentType;
  final String paymentMethod;
  final String currency;
  final double discount;
  final String discountType;
  final double paidAmount;
  final double remainingAmount;
  final String status;
  final List<InvoiceItemEntity> items;

  InvoiceEntity({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.invoiceDate,
    required this.totalAmount,
    required this.paymentType,
    required this.paymentMethod,
    required this.currency,
    required this.discount,
    required this.discountType,
    required this.paidAmount,
    required this.remainingAmount,
    required this.status,
    required this.items,
  });
}

class InvoiceItemEntity {
  final int id;
  final int stockItemId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double subTotal;

  InvoiceItemEntity({
    required this.id,
    required this.stockItemId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subTotal,
  });
}
