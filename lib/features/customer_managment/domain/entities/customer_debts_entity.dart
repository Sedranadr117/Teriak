class CustomerDebtEntity {
  final int id;
  final int customerId;
  final String customerName;
  final int pharmacyId;
  final double amount;
  final double paidAmount;
  final double remainingAmount;
  final DateTime? dueDate;
  final String notes;
  final String status;
  final DateTime createdAt;
  final DateTime? paidAt;
  final String paymentMethod;

  const CustomerDebtEntity({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.pharmacyId,
    required this.amount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.dueDate,
    required this.notes,
    required this.status,
    required this.createdAt,
    this.paidAt,
    required this.paymentMethod,
  });
}
