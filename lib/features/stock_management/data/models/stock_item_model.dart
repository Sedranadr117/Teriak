import 'package:teriak/features/stock_management/domain/entities/stock_item_entity.dart';

class StockDetailsModel {
  final int productId;
  final int totalQuantity;
  final int? minStockLevel;
  final String productType;
  final List<StockItemModel> stockItems;

  StockDetailsModel({
    required this.productId,
    required this.totalQuantity,
    required this.minStockLevel,
    required this.productType,
    required this.stockItems,
  });

  factory StockDetailsModel.fromJson(Map<String, dynamic> json) {
    final stockItemsJson = json['stockItems'];
    List<StockItemModel> stockItemsList = [];

    if (stockItemsJson != null && stockItemsJson is List) {
      stockItemsList =
          stockItemsJson.map((e) => StockItemModel.fromJson(e)).toList();
    }

    return StockDetailsModel(
      totalQuantity: json['totalQuantity'] ?? 0,
      productId: json['productId'] ?? 0,
      minStockLevel: json['minStockLevel'] as int?,
      productType: json['productType'] ?? '',
      stockItems: stockItemsList,
    );
  }

  StockDetailsEntity toEntity() {
    return StockDetailsEntity(
      productId: productId,
      totalQuantity: totalQuantity,
      minStockLevel: minStockLevel,
      productType: productType,
      stockItems: stockItems.map((e) => e.toEntity()).toList(),
    );
  }
}

class StockItemModel extends StockItemEntity {
  StockItemModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.productType,
    required super.barcodes,
    required super.quantity,
    required super.bonusQty,
    required super.total,
    required super.supplier,
    required super.categories,
    required super.minStockLevel,
    required super.expiryDate,
    required super.batchNo,
    required super.actualPurchasePrice,
    required super.sellingPrice,
    required super.dateAdded,
    required super.addedBy,
    required super.purchaseInvoiceId,
    required super.isExpired,
    required super.isExpiringSoon,
    required super.daysUntilExpiry,
    required super.pharmacyId,
    required super.purchaseInvoiceNumber,
  });

  factory StockItemModel.fromJson(Map<String, dynamic> json) {
    return StockItemModel(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'] ?? '',
      productType: json['productType'] ?? '',
      barcodes: List<String>.from(json['barcodes'] ?? []),
      quantity: json['quantity'] ?? 0,
      bonusQty: json['bonusQty'] ?? 0,
      total: (json['total'] ?? 0).toDouble(),
      supplier: json['supplier'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),
      minStockLevel: json['minStockLevel'] as int?,
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'])
          : null,
      batchNo: json['batchNo'] ?? '',
      actualPurchasePrice: (json['actualPurchasePrice'] ?? 0).toDouble(),
      sellingPrice: (json['sellingPrice'] ?? 0).toDouble(),
      dateAdded: json['dateAdded'] != null
          ? DateTime.tryParse(json['dateAdded'])
          : null,
      addedBy: json['addedBy'] ?? 0,
      purchaseInvoiceId: json['purchaseInvoiceId'] ?? 0,
      isExpired: (json['isExpired'] as bool?) ?? false,
      isExpiringSoon: (json['isExpiringSoon'] as bool?) ?? false,
      daysUntilExpiry: json['daysUntilExpiry'] ?? 0,
      pharmacyId: json['pharmacyId'] ?? 0,
      purchaseInvoiceNumber: json['purchaseInvoiceNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productType': productType,
      'barcodes': barcodes,
      'quantity': quantity,
      'bonusQty': bonusQty,
      'total': total,
      'supplier': supplier,
      'categories': categories,
      'minStockLevel': minStockLevel,
      'expiryDate': expiryDate?.toIso8601String(),
      'batchNo': batchNo,
      'actualPurchasePrice': actualPurchasePrice,
      'sellingPrice': sellingPrice,
      'dateAdded': dateAdded?.toIso8601String(),
      'addedBy': addedBy,
      'purchaseInvoiceId': purchaseInvoiceId,
      'isExpired': isExpired,
      'isExpiringSoon': isExpiringSoon,
      'daysUntilExpiry': daysUntilExpiry,
      'pharmacyId': pharmacyId,
      'purchaseInvoiceNumber': purchaseInvoiceNumber,
    };
  }

  factory StockItemModel.fromEntity(StockItemEntity e) {
    return StockItemModel(
      id: e.id,
      productId: e.productId,
      productName: e.productName,
      productType: e.productType,
      barcodes: e.barcodes,
      quantity: e.quantity,
      bonusQty: e.bonusQty,
      total: e.total,
      supplier: e.supplier,
      categories: e.categories,
      minStockLevel: e.minStockLevel,
      expiryDate: e.expiryDate,
      batchNo: e.batchNo,
      actualPurchasePrice: e.actualPurchasePrice,
      sellingPrice: e.sellingPrice,
      dateAdded: e.dateAdded,
      addedBy: e.addedBy,
      purchaseInvoiceId: e.purchaseInvoiceId,
      isExpired: e.isExpired,
      isExpiringSoon: e.isExpiringSoon,
      daysUntilExpiry: e.daysUntilExpiry,
      pharmacyId: e.pharmacyId,
      purchaseInvoiceNumber: e.purchaseInvoiceNumber,
    );
  }

  StockItemEntity toEntity() {
    return StockItemEntity(
      id: id,
      productId: productId,
      productName: productName,
      productType: productType,
      barcodes: barcodes,
      quantity: quantity,
      bonusQty: bonusQty,
      total: total,
      supplier: supplier,
      categories: categories,
      minStockLevel: minStockLevel,
      expiryDate: expiryDate,
      batchNo: batchNo,
      actualPurchasePrice: actualPurchasePrice,
      sellingPrice: sellingPrice,
      dateAdded: dateAdded,
      addedBy: addedBy,
      purchaseInvoiceId: purchaseInvoiceId,
      isExpired: isExpired,
      isExpiringSoon: isExpiringSoon,
      daysUntilExpiry: daysUntilExpiry,
      pharmacyId: pharmacyId,
      purchaseInvoiceNumber: purchaseInvoiceNumber,
    );
  }
}
