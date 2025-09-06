import 'package:teriak/features/sales_management/data/models/hive_invoice_model.dart';
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
      required super.paymentStatus,
      required super.refundStatus,
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
      status: json['status'] as String? ?? json['paymentStatus'] as String,
      paymentStatus: json['paymentStatus'] as String? ?? '',
      refundStatus: json['refundStatus'] as String? ?? '',
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
      'status': status,
      'paymentStatus': paymentStatus,
      'refundStatus': refundStatus,
      'debtDueDate': debtDueDate,
      'items': (items as List<InvoiceItemModel>)
          .map((item) => item.toJson())
          .toList(),
    };
  }

  static InvoiceModel fromHiveInvoice(HiveSaleInvoice hiveInvoice) {
    return InvoiceModel(
      id: hiveInvoice.id,
      customerId: hiveInvoice.customerId,
      customerName: hiveInvoice.customerName,
      invoiceDate: hiveInvoice.invoiceDate,
      totalAmount: hiveInvoice.totalAmount,
      paymentType: hiveInvoice.paymentType,
      paymentMethod: hiveInvoice.paymentMethod,
      currency: hiveInvoice.currency,
      discount: hiveInvoice.discount,
      discountType: hiveInvoice.discountType,
      paidAmount: hiveInvoice.paidAmount,
      remainingAmount: hiveInvoice.remainingAmount,
      status: hiveInvoice.status,
      paymentStatus: hiveInvoice.paymentStatus,
      refundStatus: hiveInvoice.refundStatus,
      debtDueDate: hiveInvoice.debtDueDate,
      items: hiveInvoice.items
          .map((item) => InvoiceItemModel(
                id: item.id,
                productName: item.productName,
                quantity: item.quantity,
                refundedQuantity: item.refundedQuantity,
                availableForRefund: item.availableForRefund,
                unitPrice: item.unitPrice,
                subTotal: item.subTotal,
                stockItemId: item.productId,
              ))
          .toList(),
    );
  }
}

class InvoiceItemModel extends InvoiceItemEntity {
  InvoiceItemModel(
      {required super.id,
      required super.stockItemId,
      required super.productName,
      required super.quantity,
      required super.refundedQuantity,
      required super.availableForRefund,
      required super.unitPrice,
      required super.subTotal});

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return InvoiceItemModel(
      id: json['id'] as int,
      stockItemId: json['stockItemId'] as int,
      productName: json['productName'] as String,
      quantity: json['quantity'] as int,
      refundedQuantity: json['refundedQuantity'] as int? ?? 0,
      availableForRefund: json['availableForRefund'] as int? ?? 0,
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
      'refundedQuantity': refundedQuantity,
      'availableForRefund': availableForRefund,
      'unitPrice': unitPrice,
      'subTotal': subTotal,
    };
  }
}
