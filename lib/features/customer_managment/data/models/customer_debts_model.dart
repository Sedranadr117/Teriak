import 'package:teriak/features/customer_managment/domain/entities/customer_debts_entity.dart';

class CustomerDebtsModel extends CustomerDebtEntity {
  CustomerDebtsModel(
      {required super.id,
      required super.customerId,
      required super.customerName,
      required super.pharmacyId,
      required super.amount,
      required super.paidAmount,
      required super.remainingAmount,
      required super.status,
      required super.createdAt,
      required super.paymentMethod,
      required super.dueDate,
      required super.notes,
      required super.paidAt});

  factory CustomerDebtsModel.fromJson(Map<String, dynamic> json) {
    return CustomerDebtsModel(
      id: json['id'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      pharmacyId: json['pharmacyId'],
      amount: (json['amount'] as num).toDouble(),
      paidAmount: (json['paidAmount'] as num).toDouble(),
      remainingAmount: (json['remainingAmount'] as num).toDouble(),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
      notes: json['notes'],
      status: json['status'],
      paymentMethod: json['paymentMethod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "customerId": customerId,
      "customerName": customerName,
      "pharmacyId": pharmacyId,
      "amount": amount,
      "paidAmount": paidAmount,
      "remainingAmount": remainingAmount,
      "dueDate": dueDate,
      "notes": notes,
      "status": status,
      "createdAt": createdAt,
      "paidAt": paidAt,
      "paymentMethod": paymentMethod,
    };
  }
}
