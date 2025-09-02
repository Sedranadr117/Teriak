import 'package:teriak/features/sales_management/domain/entities/invoice_entity.dart';

class InvoiceModel extends InvoiceEntity {
  InvoiceModel(
      {required super.id,
      required super.customerId,
      required super.customerName,
      required super.invoiceDate,
      required super.totalAmount,
      required super.paymentType,
      required super.paymentMethod,
      required super.currency,
      required super.discount,
      required super.discountType,
      required super.paidAmount,
      required super.remainingAmount,
      required super.status,
      required super.items,
      required super.debtDueDate});

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] as int,
      customerId: json['customerId'] as int,
      customerName: json['customerName'] as String,
      invoiceDate: json['invoiceDate'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentType: json['paymentType'] as String,
      paymentMethod: json['paymentMethod'] as String,
      currency: json['currency'] as String,
      discount: (json['discount'] as num).toDouble(),
      discountType: json['discountType'] as String,
      paidAmount: (json['paidAmount'] as num).toDouble(),
      remainingAmount: (json['remainingAmount'] as num).toDouble(),
      status: json['paymentStatus'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => InvoiceItemModel.fromJson(item))
          .toList(),
      debtDueDate: json['debtDueDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'invoiceDate': invoiceDate,
      'totalAmount': totalAmount,
      'paymentType': paymentType,
      'paymentMethod': paymentMethod,
      'currency': currency,
      'discount': discount,
      'discountType': discountType,
      'paidAmount': paidAmount,
      'remainingAmount': remainingAmount,
      'paymentStatus': status,
      'debtDueDate': debtDueDate,
      'items': (items as List<InvoiceItemModel>)
          .map((item) => item.toJson())
          .toList(),
    };
  }
}

class InvoiceItemModel extends InvoiceItemEntity {
  InvoiceItemModel(
      {required super.id,
      required super.stockItemId,
      required super.productName,
      required super.quantity,
      required super.unitPrice,
      required super.subTotal});

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return InvoiceItemModel(
      id: json['id'] as int,
      stockItemId: json['stockItemId'] as int,
      productName: json['productName'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      subTotal: (json['subTotal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stockItemId': stockItemId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'subTotal': subTotal,
    };
  }
}
