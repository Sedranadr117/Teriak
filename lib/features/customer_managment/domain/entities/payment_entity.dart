class PaymentEntity {
  final int customerId;
  final double totalPaymentAmount;
  final String paymentMethod;
  final String notes;

  PaymentEntity({
    required this.customerId,
    required this.totalPaymentAmount,
    required this.paymentMethod,
    this.notes = '',
  });
}
