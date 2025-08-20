// lib/features/purchase_invoices/data/models/purchase_invoice_model.dart
import 'package:teriak/core/databases/api/end_points.dart';
import '../../domain/entities/purchase_invoice_entity.dart';
import 'purchase_invoice_item_model.dart';

class PurchaseInvoiceModel extends PurchaseInvoiceEntity {
  PurchaseInvoiceModel({
    required super.id,
    required super.purchaseOrderId,
    required super.supplierName,
    required super.currency,
    required super.total,
    super.invoiceNumber,
    required super.createdAt,
    required super.createdBy,
    required super.items,
  });

  factory PurchaseInvoiceModel.fromJson(Map<String, dynamic> json) {
    return PurchaseInvoiceModel(
      id: json[ApiKeys.id],
      purchaseOrderId: json[ApiKeys.purchaseOrderId],
      supplierName: json[ApiKeys.supplierName],
      currency: json[ApiKeys.currency],
      total: (json[ApiKeys.total] ?? 0).toDouble(),
      invoiceNumber: json[ApiKeys.invoiceNumber],
      createdAt:List<int>.from(json[ApiKeys.createdAt] ?? []),
      createdBy: json[ApiKeys.createdBy],
      items: (json[ApiKeys.items] as List<dynamic>)
          .map((item) => PurchaseInvoiceItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.purchaseOrderId: purchaseOrderId,
      ApiKeys.supplierName: supplierName,
      ApiKeys.currency: currency,
      ApiKeys.total: total,
      ApiKeys.invoiceNumber: invoiceNumber,
      ApiKeys.createdAt:createdAt,
      ApiKeys.createdBy: createdBy,
      ApiKeys.items: items
          .map((item) => (item as PurchaseInvoiceItemModel).toJson())
          .toList(),
    };
  }
    DateTime get creationDateTime {
    if (createdAt.length >= 6) {
      return DateTime(
        createdAt[0], // year
        createdAt[1], // month
        createdAt[2], // day
        createdAt[3], // hour
        createdAt[4], // minute
        createdAt[5], // second
      );
    }
    return DateTime.now();
  }

  String get formattedCreationDateTime {
    final date = creationDateTime;
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    final formattedTime =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    return '$formattedDate, $formattedTime';
  }

}
