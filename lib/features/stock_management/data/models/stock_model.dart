import 'package:teriak/features/stock_management/domain/entities/stock_entity.dart';

class StockModel extends StockEntity {
  StockModel({
    required super.productId,
    required super.productName,
    super.productNameAr,
    super.productNameEn,
    required super.productType,
    required super.barcodes,
    required super.totalQuantity,
    required super.totalBonusQuantity,
    required super.actualPurchasePrice,
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
    required super.dualCurrencyDisplay,
    required super.actualPurchasePriceUSD,
    required super.totalValueUSD,
    required super.sellingPriceUSD,
    required super.exchangeRateSYPToUSD,
    required super.conversionTimestampSYPToUSD,
    required super.rateSource,
    required super.id,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'] ?? '',
      productNameAr: json['productNameAr'] as String?,
      productNameEn: json['productNameEn'] as String?,
      productType: json['productType'] ?? '',
      barcodes: List<String>.from(json['barcodes'] ?? []),
      totalQuantity: json['totalQuantity'] ?? 0,
      totalBonusQuantity: json['totalBonusQuantity'] ?? 0,
      actualPurchasePrice: json['actualPurchasePrice'] is num
          ? (json['actualPurchasePrice'] as num).toDouble()
          : double.tryParse(json['actualPurchasePrice'].toString()) ?? 0.0,
      totalValue: json['totalValue'] is num
          ? (json['totalValue'] as num).toDouble()
          : double.tryParse(json['totalValue'].toString()) ?? 0.0,
      categories: List<String>.from(json['categories'] ?? []),
      sellingPrice: json['sellingPrice'] is num
          ? (json['sellingPrice'] as num).toDouble()
          : double.tryParse(json['sellingPrice'].toString()) ?? 0.0,
      minStockLevel: json['minStockLevel'] as int?,
      hasExpiredItems: (json['hasExpiredItems'] as bool?) ?? false,
      hasExpiringSoonItems: (json['hasExpiringSoonItems'] as bool?) ?? false,
      earliestExpiryDate: json['earliestExpiryDate'] != null
          ? DateTime.tryParse(json['earliestExpiryDate'])
          : null,
      latestExpiryDate: json['latestExpiryDate'] != null
          ? DateTime.tryParse(json['latestExpiryDate'])
          : null,
      numberOfBatches: json['numberOfBatches'] ?? 0,
      pharmacyId: json['pharmacyId'] ?? 0,
      dualCurrencyDisplay: (json['dualCurrencyDisplay'] as bool?) ?? false,
      actualPurchasePriceUSD: json['actualPurchasePriceUSD'] is num
          ? (json['actualPurchasePriceUSD'] as num).toDouble()
          : double.tryParse(json['actualPurchasePriceUSD'].toString()) ?? 0.0,
      totalValueUSD: json['totalValueUSD'] is num
          ? (json['totalValueUSD'] as num).toDouble()
          : double.tryParse(json['totalValueUSD'].toString()) ?? 0.0,
      sellingPriceUSD: json['sellingPriceUSD'] is num
          ? (json['sellingPriceUSD'] as num).toDouble()
          : double.tryParse(json['sellingPriceUSD'].toString()) ?? 0.0,
      exchangeRateSYPToUSD: json['exchangeRateSYPToUSD'] is num
          ? (json['exchangeRateSYPToUSD'] as num).toDouble()
          : double.tryParse(json['exchangeRateSYPToUSD'].toString()) ?? 0.0,
      conversionTimestampSYPToUSD: json['conversionTimestampSYPToUSD'] != null
          ? DateTime.tryParse(json['conversionTimestampSYPToUSD'])
          : null,
      rateSource: json['rateSource'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productNameAr': productNameAr,
      'productNameEn': productNameEn,
      'productType': productType,
      'barcodes': barcodes,
      'totalQuantity': totalQuantity,
      'totalBonusQuantity': totalBonusQuantity,
      'actualPurchasePrice': actualPurchasePrice,
      'totalValue': totalValue,
      'categories': categories,
      'sellingPrice': sellingPrice,
      'minStockLevel': minStockLevel,
      'hasExpiredItems': hasExpiredItems,
      'hasExpiringSoonItems': hasExpiringSoonItems,
      'earliestExpiryDate': earliestExpiryDate?.toIso8601String(),
      'latestExpiryDate': latestExpiryDate?.toIso8601String(),
      'numberOfBatches': numberOfBatches,
      'pharmacyId': pharmacyId,
      'dualCurrencyDisplay': dualCurrencyDisplay,
      'actualPurchasePriceUSD': actualPurchasePriceUSD,
      'totalValueUSD': totalValueUSD,
      'sellingPriceUSD': sellingPriceUSD,
      'exchangeRateSYPToUSD': exchangeRateSYPToUSD,
      'conversionTimestampSYPToUSD':
          conversionTimestampSYPToUSD?.toIso8601String(),
      'rateSource': rateSource,
    };
  }

  StockEntity toEntity() {
    return StockEntity(
      id: id,
      productId: productId,
      productName: productName,
      productNameAr: productNameAr,
      productNameEn: productNameEn,
      productType: productType,
      barcodes: barcodes,
      totalQuantity: totalQuantity,
      totalBonusQuantity: totalBonusQuantity,
      actualPurchasePrice: actualPurchasePrice,
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
      dualCurrencyDisplay: dualCurrencyDisplay,
      actualPurchasePriceUSD: actualPurchasePriceUSD,
      totalValueUSD: totalValueUSD,
      sellingPriceUSD: sellingPriceUSD,
      exchangeRateSYPToUSD: exchangeRateSYPToUSD,
      conversionTimestampSYPToUSD: conversionTimestampSYPToUSD,
      rateSource: rateSource,
    );
  }

  factory StockModel.fromEntity(StockEntity e) {
    return StockModel(
      productId: e.productId,
      productName: e.productName,
      productNameAr: e.productNameAr,
      productNameEn: e.productNameEn,
      productType: e.productType,
      barcodes: e.barcodes,
      totalQuantity: e.totalQuantity,
      totalBonusQuantity: e.totalBonusQuantity,
      actualPurchasePrice: e.actualPurchasePrice,
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
      dualCurrencyDisplay: e.dualCurrencyDisplay,
      actualPurchasePriceUSD: e.actualPurchasePriceUSD,
      totalValueUSD: e.totalValueUSD,
      sellingPriceUSD: e.sellingPriceUSD,
      exchangeRateSYPToUSD: e.exchangeRateSYPToUSD,
      conversionTimestampSYPToUSD: e.conversionTimestampSYPToUSD,
      rateSource: e.rateSource,
      id: e.id,
    );
  }
}
