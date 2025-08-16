// lib/features/purchase_invoices/data/models/purchase_invoice_item_model.dart
import '../../domain/entities/purchase_invoice_item_entity.dart';

class PurchaseInvoiceItemModel extends PurchaseInvoiceItemEntity {

  PurchaseInvoiceItemModel({
    required super.id,
    required super.productName,
    required super.receivedQty,
    required super.bonusQty,
    required super.invoicePrice,
    required super.actualPrice,
    required super.batchNo,
    required super.expiryDate,
  });

  factory PurchaseInvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return PurchaseInvoiceItemModel(
      id: json['id'] ?? 0,
      productName: json['productName'] ?? '',
      receivedQty: json['receivedQty'] ?? 0,
      bonusQty: json['bonusQty'] ?? 0,
      invoicePrice: (json['invoicePrice'] as num?)?.toDouble() ?? 0.0,
      actualPrice: (json['actualPrice'] as num?)?.toDouble() ?? 0.0,
      batchNo: json['batchNo'] ?? '',
      expiryDate: List<int>.from(json['expiryDate'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'receivedQty': receivedQty,
      'bonusQty': bonusQty,
      'invoicePrice': invoicePrice,
      'actualPrice': actualPrice,
      'batchNo': batchNo,
      'expiryDate': expiryDate,
    };
  }

  DateTime get expiryDateTime {
    if (expiryDate.length >= 3) {
      return DateTime(
        expiryDate[0], // year
        expiryDate[1], // month
        expiryDate[2], // day
      );
    }
    return DateTime.now();
  }

  String get formattedExpiryDate {
    final date = expiryDateTime;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
