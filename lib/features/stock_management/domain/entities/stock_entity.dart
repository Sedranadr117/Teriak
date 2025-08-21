class StockEntity {
  final int id;
  final int productId;
  final String productName;
  final String productType;
  final List<String> barcodes;
  final int totalQuantity;
  final int totalBonusQuantity;
  final double averagePurchasePrice;
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

  const StockEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productType,
    required this.barcodes,
    required this.totalQuantity,
    required this.totalBonusQuantity,
    required this.averagePurchasePrice,
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
  });
}
