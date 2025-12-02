import 'package:hive/hive.dart';
import 'package:teriak/features/stock_management/data/models/Stock_model.dart';
import 'package:teriak/features/stock_management/domain/entities/stock_entity.dart';

part 'hive_stock_model.g.dart';

@HiveType(typeId: 2)
class HiveStockModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int productId;

  @HiveField(2)
  final String productName;

  @HiveField(25)
  final String? productNameAr; // Arabic name for search

  @HiveField(3)
  final String productType;

  @HiveField(4)
  final List<String> barcodes;

  @HiveField(5)
  final int totalQuantity;

  @HiveField(6)
  final int totalBonusQuantity;

  @HiveField(7)
  final double actualPurchasePrice;

  @HiveField(8)
  final double totalValue;

  @HiveField(9)
  final List<String> categories;

  @HiveField(10)
  final double sellingPrice;

  @HiveField(11)
  final int? minStockLevel;

  @HiveField(12)
  final bool hasExpiredItems;

  @HiveField(13)
  final bool hasExpiringSoonItems;

  @HiveField(14)
  final DateTime? earliestExpiryDate;

  @HiveField(15)
  final DateTime? latestExpiryDate;

  @HiveField(16)
  final int numberOfBatches;

  @HiveField(17)
  final int pharmacyId;

  @HiveField(18)
  final bool dualCurrencyDisplay;

  @HiveField(19)
  final double actualPurchasePriceUSD;

  @HiveField(20)
  final double totalValueUSD;

  @HiveField(21)
  final double sellingPriceUSD;

  @HiveField(22)
  final double exchangeRateSYPToUSD;

  @HiveField(23)
  final DateTime? conversionTimestampSYPToUSD;

  @HiveField(24)
  final String rateSource;

  HiveStockModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.productNameAr,
    required this.productType,
    required this.barcodes,
    required this.totalQuantity,
    required this.totalBonusQuantity,
    required this.actualPurchasePrice,
    required this.totalValue,
    required this.categories,
    required this.sellingPrice,
    required this.minStockLevel,
    required this.hasExpiredItems,
    required this.hasExpiringSoonItems,
    required this.earliestExpiryDate,
    required this.latestExpiryDate,
    required this.numberOfBatches,
    required this.pharmacyId,
    required this.dualCurrencyDisplay,
    required this.actualPurchasePriceUSD,
    required this.totalValueUSD,
    required this.sellingPriceUSD,
    required this.exchangeRateSYPToUSD,
    required this.conversionTimestampSYPToUSD,
    required this.rateSource,
  });

  factory HiveStockModel.fromStockModel(StockModel model,
      {String? arabicName}) {
    return HiveStockModel(
      id: model.id,
      productId: model.productId,
      productName: model.productName,
      productNameAr: arabicName ?? model.productNameAr,
      productType: model.productType,
      barcodes: List<String>.from(model.barcodes),
      totalQuantity: model.totalQuantity,
      totalBonusQuantity: model.totalBonusQuantity,
      actualPurchasePrice: model.actualPurchasePrice,
      totalValue: model.totalValue,
      categories: List<String>.from(model.categories),
      sellingPrice: model.sellingPrice,
      minStockLevel: model.minStockLevel,
      hasExpiredItems: model.hasExpiredItems,
      hasExpiringSoonItems: model.hasExpiringSoonItems,
      earliestExpiryDate: model.earliestExpiryDate,
      latestExpiryDate: model.latestExpiryDate,
      numberOfBatches: model.numberOfBatches,
      pharmacyId: model.pharmacyId,
      dualCurrencyDisplay: model.dualCurrencyDisplay,
      actualPurchasePriceUSD: model.actualPurchasePriceUSD,
      totalValueUSD: model.totalValueUSD,
      sellingPriceUSD: model.sellingPriceUSD,
      exchangeRateSYPToUSD: model.exchangeRateSYPToUSD,
      conversionTimestampSYPToUSD: model.conversionTimestampSYPToUSD,
      rateSource: model.rateSource,
    );
  }

  StockEntity toEntity() {
    return StockEntity(
      id: id,
      productId: productId,
      productName: productName,
      productNameAr: productNameAr,
      productNameEn: null, // Hive model doesn't store English name separately
      productType: productType,
      barcodes: List<String>.from(barcodes),
      totalQuantity: totalQuantity,
      totalBonusQuantity: totalBonusQuantity,
      actualPurchasePrice: actualPurchasePrice,
      totalValue: totalValue,
      categories: List<String>.from(categories),
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
}
