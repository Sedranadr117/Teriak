import 'package:hive/hive.dart';
import 'package:teriak/features/customer_managment/data/models/customer_model.dart';
import 'package:teriak/features/customer_managment/domain/entities/customer_entity.dart';

part 'hive_customer_model.g.dart';

@HiveType(typeId: 3)
class HiveCustomerModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phoneNumber;

  @HiveField(3)
  final String address;

  @HiveField(4)
  final String? notes;

  @HiveField(5)
  final double totalDebt;

  @HiveField(6)
  final double totalPaid;

  @HiveField(7)
  final double remainingDebt;

  @HiveField(8)
  final int activeDebtsCount;

  @HiveField(9)
  final List<Map<String, dynamic>> debts;

  HiveCustomerModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.address,
    this.notes,
    required this.totalDebt,
    required this.totalPaid,
    required this.remainingDebt,
    required this.activeDebtsCount,
    required this.debts,
  });

  factory HiveCustomerModel.fromCustomerModel(CustomerModel model) {
    return HiveCustomerModel(
      id: model.id,
      name: model.name,
      phoneNumber: model.phoneNumber,
      address: model.address,
      notes: model.notes,
      totalDebt: model.totalDebt,
      totalPaid: model.totalPaid,
      remainingDebt: model.remainingDebt,
      activeDebtsCount: model.activeDebtsCount,
      debts: model.debts
          .map((debt) => {
                'id': debt.id,
                'customerId': debt.customerId,
                'customerName': debt.customerName,
                'amount': debt.amount,
                'paidAmount': debt.paidAmount,
                'remainingAmount': debt.remainingAmount,
                'dueDate': debt.dueDate,
                'notes': debt.notes,
                'status': debt.status,
              })
          .toList(),
    );
  }

  CustomerEntity toEntity() {
    return CustomerEntity(
      id: id,
      name: name,
      phoneNumber: phoneNumber,
      address: address,
      notes: notes,
      totalDebt: totalDebt,
      totalPaid: totalPaid,
      remainingDebt: remainingDebt,
      activeDebtsCount: activeDebtsCount,
      debts: debts
          .map((debt) => DebtEntity(
                id: debt['id'] as int,
                customerId: debt['customerId'] as int,
                customerName: debt['customerName'] as String,
                amount: (debt['amount'] as num).toDouble(),
                paidAmount: (debt['paidAmount'] as num).toDouble(),
                remainingAmount: (debt['remainingAmount'] as num).toDouble(),
                dueDate: debt['dueDate'] as String,
                notes: debt['notes'] as String?,
                status: debt['status'] as String,
              ))
          .toList(),
    );
  }
}
