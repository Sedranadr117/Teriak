import 'package:teriak/features/customer_managment/domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  PaymentModel({
    required super.customerId,
    required super.totalPaymentAmount,
    required super.paymentMethod,
    super.notes,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      customerId: json['customerId'],
      totalPaymentAmount: (json['totalPaymentAmount'] as num).toDouble(),
      paymentMethod:
          json['paymentMethod'] ?? 'CASH', // Default value if missing
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'totalPaymentAmount': totalPaymentAmount,
      'paymentMethod': paymentMethod,
      if (notes.isNotEmpty) 'notes': notes,
    };
  }
}
