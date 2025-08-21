class StockDetailsEntity {
  final int productId;
  final int totalQuantity;
  final int? minStockLevel;
  final String productType;
  final List<StockItemEntity> stockItems;

  StockDetailsEntity({
    required this.productId,
    required this.totalQuantity,
    required this.minStockLevel,
    required this.productType,
    required this.stockItems,
  });
}

class StockItemEntity {
  final int id;
  final int productId;
  final String productName;
  final String productType;
  final List<String> barcodes;
  final int quantity;
  final int bonusQty;
  final double total;
  final String supplier;
  final List<String> categories;
  final int? minStockLevel;
  final DateTime? expiryDate;
  final String batchNo;
  final double actualPurchasePrice;
  final double sellingPrice;
  final DateTime? dateAdded;
  final int addedBy;
  final int purchaseInvoiceId;
  final bool isExpired;
  final bool isExpiringSoon;
  final int daysUntilExpiry;
  final int pharmacyId;
  final String purchaseInvoiceNumber;

  StockItemEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productType,
    required this.barcodes,
    required this.quantity,
    required this.bonusQty,
    required this.total,
    required this.supplier,
    required this.categories,
    required this.minStockLevel,
    required this.expiryDate,
    required this.batchNo,
    required this.actualPurchasePrice,
    required this.sellingPrice,
    required this.dateAdded,
    required this.addedBy,
    required this.purchaseInvoiceId,
    required this.isExpired,
    required this.isExpiringSoon,
    required this.daysUntilExpiry,
    required this.pharmacyId,
    required this.purchaseInvoiceNumber,
  });
}
