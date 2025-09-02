import 'package:teriak/features/customer_managment/domain/entities/customer_entity.dart';

class DebtModel extends DebtEntity {
  DebtModel(
      {required super.id,
      required super.customerId,
      required super.customerName,
      required super.amount,
      required super.paidAmount,
      required super.remainingAmount,
      required super.dueDate,
      required super.status,
      required super.notes});
  factory DebtModel.fromJson(Map<String, dynamic> json) {
    return DebtModel(
      id: json['id'] ?? 0,
      customerId: json['customerId'] ?? 0,
      customerName: json['customerName'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      paidAmount: (json['paidAmount'] ?? 0).toDouble(),
      remainingAmount: (json['remainingAmount'] ?? 0).toDouble(),
      dueDate: json['dueDate'] ?? '',
      notes: json['notes'],
      status: json['status'] ?? '',
    );
  }
}

class CustomerModel extends CustomerEntity {
  CustomerModel(
      {required super.id,
      required super.name,
      required super.phoneNumber,
      required super.address,
      required super.notes,
      required super.totalDebt,
      required super.remainingDebt,
      required super.totalPaid,
      required super.activeDebtsCount,
      required super.debts});
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      notes: json['notes'],
      totalDebt: (json['totalDebt'] ?? 0),
      totalPaid: (json['totalPaid'] ?? 0),
      remainingDebt: (json['remainingDebt'] ?? 0),
      activeDebtsCount: json['activeDebtsCount'] ?? 0,
      debts: json['debts'] != null
          ? List<DebtModel>.from(
              (json['debts'] as List).map((e) => DebtModel.fromJson(e)))
          : [],
    );
  }
}
