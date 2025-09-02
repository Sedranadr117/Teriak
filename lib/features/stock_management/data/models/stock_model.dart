import 'package:teriak/features/stock_management/domain/entities/stock_entity.dart';

class StockModel extends StockEntity {
  StockModel({
    required super.productId,
    required super.productName,
    required super.productType,
    required super.barcodes,
    required super.totalQuantity,
    required super.totalBonusQuantity,
    required super.averagePurchasePrice,
    required super.totalValue,
    required super.categories,
    required super.sellingPrice,
    required super.minStockLevel,
    required super.hasExpiredItems,
    required super.hasExpiringSoonItems,
    required super.earliestExpiryDate,
    required super.latestExpiryDate,
    required super.numberOfBatches,
    required super.pharmacyId,
    required super.id,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'] ?? '',
      productType: json['productType'] ?? '',
      barcodes: List<String>.from(json['barcodes'] ?? []),
      totalQuantity: json['totalQuantity'] ?? 0,
      totalBonusQuantity: json['totalBonusQuantity'] ?? 0,
      averagePurchasePrice: json['averagePurchasePrice'] is num
          ? (json['averagePurchasePrice'] as num).toDouble()
          : double.tryParse(json['averagePurchasePrice'].toString()) ?? 0.0,
      totalValue: json['totalValue'] is num
          ? (json['totalValue'] as num).toDouble()
          : double.tryParse(json['totalValue'].toString()) ?? 0.0,
      categories: List<String>.from(json['categories'] ?? []),
      sellingPrice: json['sellingPrice'] is num
          ? (json['sellingPrice'] as num).toDouble()
          : double.tryParse(json['sellingPrice'].toString()) ?? 0.0,
      minStockLevel: json['minStockLevel'] as int?, // ✅
      hasExpiredItems: (json['hasExpiredItems'] as bool?) ?? false,
      hasExpiringSoonItems: (json['hasExpiringSoonItems'] as bool?) ?? false,
      earliestExpiryDate: json['earliestExpiryDate'] != null
          ? DateTime.tryParse(json['earliestExpiryDate'])
          : null, // ✅
      latestExpiryDate: json['latestExpiryDate'] != null
          ? DateTime.tryParse(json['latestExpiryDate'])
          : null, // ✅
      numberOfBatches: json['numberOfBatches'] ?? 0,
      pharmacyId: json['pharmacyId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productType': productType,
      'barcodes': barcodes,
      'totalQuantity': totalQuantity,
      'totalBonusQuantity': totalBonusQuantity,
      'averagePurchasePrice': averagePurchasePrice,
      'totalValue': totalValue,
      'categories': categories,
      'sellingPrice': sellingPrice,
      'minStockLevel': minStockLevel,
      'hasExpiredItems': hasExpiredItems,
      'hasExpiringSoonItems': hasExpiringSoonItems,
      'earliestExpiryDate': earliestExpiryDate?.toIso8601String(), // ✅
      'latestExpiryDate': latestExpiryDate?.toIso8601String(), // ✅
      'numberOfBatches': numberOfBatches,
      'pharmacyId': pharmacyId,
    };
  }

  StockEntity toEntity() {
    return StockEntity(
      id: id,
      productId: productId,
      productName: productName,
      productType: productType,
      barcodes: barcodes,
      totalQuantity: totalQuantity,
      totalBonusQuantity: totalBonusQuantity,
      averagePurchasePrice: averagePurchasePrice,
      totalValue: totalValue,
      categories: categories,
      sellingPrice: sellingPrice,
      minStockLevel: minStockLevel,
      hasExpiredItems: hasExpiredItems,
      hasExpiringSoonItems: hasExpiringSoonItems,
      earliestExpiryDate: earliestExpiryDate,
      latestExpiryDate: latestExpiryDate,
      numberOfBatches: numberOfBatches,
      pharmacyId: pharmacyId,
    );
  }

  factory StockModel.fromEntity(StockEntity e) {
    return StockModel(
      productId: e.productId,
      productName: e.productName,
      productType: e.productType,
      barcodes: e.barcodes,
      totalQuantity: e.totalQuantity,
      totalBonusQuantity: e.totalBonusQuantity,
      averagePurchasePrice: e.averagePurchasePrice,
      totalValue: e.totalValue,
      categories: e.categories,
      sellingPrice: e.sellingPrice,
      minStockLevel: e.minStockLevel,
      hasExpiredItems: e.hasExpiredItems,
      hasExpiringSoonItems: e.hasExpiringSoonItems,
      earliestExpiryDate: e.earliestExpiryDate,
      latestExpiryDate: e.latestExpiryDate,
      numberOfBatches: e.numberOfBatches,
      pharmacyId: e.pharmacyId,
      id: e.id,
    );
  }
}
