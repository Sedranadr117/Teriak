// debt_entity.dart
class DebtEntity {
  final int id;
  final int customerId;
  final String customerName;
  final double amount;
  final double paidAmount;
  final double remainingAmount;
  final String dueDate;
  final String? notes;
  final String status;

  DebtEntity({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.amount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.dueDate,
    this.notes,
    required this.status,
  });
}

// customer_entity.dart

class CustomerEntity {
  final int id;
  final String name;
  final String phoneNumber;
  final String address;
  final String? notes;
  final double totalDebt;
  final double totalPaid;
  final double remainingDebt;
  final int activeDebtsCount;
  final List<DebtEntity> debts;

  CustomerEntity({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.notes,
    required this.totalDebt,
    required this.totalPaid,
    required this.remainingDebt,
    required this.activeDebtsCount,
    required this.debts,
  });
}
