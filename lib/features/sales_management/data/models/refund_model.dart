import 'package:teriak/features/sales_management/domain/entities/refund_entity.dart';
import 'package:intl/intl.dart';

class RefundItemModel extends RefundItemEntity {
  RefundItemModel({
    required super.itemId,
    required super.productName,
    required super.quantity,
    required super.unitPrice,
    required super.subtotal,
    required super.itemRefundReason,
  });

  factory RefundItemModel.fromJson(Map<String, dynamic> json) {
    return RefundItemModel(
      itemId: json['itemId'] ?? 0,
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      itemRefundReason: json['itemRefundReason'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'quantity': quantity,
      'itemRefundReason': itemRefundReason,
    };
  }
}

class SaleRefundModel extends SaleRefundEntity {
  SaleRefundModel({
    required super.refundId,
    required super.saleInvoiceId,
    required super.totalRefundAmount,
    required super.refundReason,
    required super.refundDate,
    required List<RefundItemModel> super.refundedItems,
    required super.stockRestored,
    required super.customerId,
    required super.customerName,
    required super.originalInvoiceAmount,
    required super.originalInvoicePaidAmount,
    required super.originalInvoiceRemainingAmount,
    required super.paymentType,
    required super.paymentMethod,
    required super.currency,
    required super.customerTotalDebt,
    required super.customerActiveDebtsCount,
  });

  factory SaleRefundModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedRefundDate;
    final rawDate = json['refundDate'];
    if (rawDate is String) {
      try {
        parsedRefundDate = DateFormat('dd-MM-yyyy, HH:mm:ss').parse(rawDate);
      } catch (_) {
        try {
          parsedRefundDate = DateTime.parse(rawDate);
        } catch (_) {
          parsedRefundDate = DateTime.now();
        }
      }
    } else {
      parsedRefundDate = DateTime.now();
    }

    return SaleRefundModel(
      refundId: json['refundId'] ?? 0,
      saleInvoiceId: json['saleInvoiceId'] ?? 0,
      totalRefundAmount: (json['totalRefundAmount'] ?? 0).toDouble(),
      refundReason: json['refundReason'] ?? '',
      refundDate: parsedRefundDate,
      refundedItems: ((json['refundedItems'] as List?) ?? const [])
          .map((e) => RefundItemModel.fromJson(e))
          .toList(),
      stockRestored: json['stockRestored'] ?? false,
      customerId: json['customerId'] ?? 0,
      customerName: json['customerName'] ?? '',
      originalInvoiceAmount: (json['originalInvoiceAmount'] ?? 0).toDouble(),
      originalInvoicePaidAmount:
          (json['originalInvoicePaidAmount'] ?? 0).toDouble(),
      originalInvoiceRemainingAmount:
          (json['originalInvoiceRemainingAmount'] ?? 0).toDouble(),
      paymentType: json['paymentType'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      currency: json['currency'] ?? '',
      customerTotalDebt: (json['customerTotalDebt'] ?? 0).toDouble(),
      customerActiveDebtsCount: json['customerActiveDebtsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refundedItems':
          refundedItems.map((e) => (e as RefundItemModel).toJson()).toList(),
      'refundReason': refundReason,
      'totalRefundAmount': totalRefundAmount,
      "customerName": customerName,
      "paymentMethod": paymentMethod,
      "refundDate": refundDate,
    };
  }
}
