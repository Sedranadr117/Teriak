class StockEntity {
  final int id;
  final int productId;
  final String productName;
  final String? productNameAr; // Arabic name
  final String? productNameEn; // English name
  final String productType;
  final List<String> barcodes;
  final int totalQuantity;
  final int totalBonusQuantity;
  final double actualPurchasePrice;
  final double totalValue;
  final List<String> categories;
  final double sellingPrice;
  final int? minStockLevel;
  final bool hasExpiredItems;
  final bool hasExpiringSoonItems;
  final DateTime? earliestExpiryDate;
  final DateTime? latestExpiryDate;
  final int numberOfBatches;
  final int pharmacyId;
  final bool dualCurrencyDisplay;
  final double actualPurchasePriceUSD;
  final double totalValueUSD;
  final double sellingPriceUSD;
  final double exchangeRateSYPToUSD;
  final DateTime? conversionTimestampSYPToUSD;
  final String rateSource;

  const StockEntity({
    required this.id,
    required this.productId,
    required this.productName,
    this.productNameAr,
    this.productNameEn,
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
}
