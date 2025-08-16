import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/data/models/purchase_invoice_model.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/domain/entities/paginated_purchase_invoice_entity.dart';

class PaginatedInvoiceModel extends PaginatedInvoiceEntity {
  PaginatedInvoiceModel({
    required super.content,
    required super.page,
    required super.size,
    required super.totalElements,
    required super.totalPages,
    required super.hasNext,
    required super.hasPrevious,
  });

  factory PaginatedInvoiceModel.fromJson(Map<String, dynamic> json) {
    return PaginatedInvoiceModel(
      content: (json['content'] as List<dynamic>?)
              ?.map((item) => PurchaseInvoiceModel.fromJson(item))
              .toList() ??
          [],
      page: json['page'] ?? 0,
      size: json['size'] ?? 10,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNext: json['hasNext'] ?? false,
      hasPrevious: json['hasPrevious'] ?? false,
    );
  }
}
