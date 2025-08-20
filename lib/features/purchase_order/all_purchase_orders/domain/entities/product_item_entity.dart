class ProductItemEntity {
  final int id;
  final String productName;
  final int quantity;
  final double price;
  final String barcode;
  final int productId;
  final String productType;
  final double refSellingPrice;
  final int? minStockLevel;

  const ProductItemEntity({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.barcode,
    required this.productId,
    required this.productType,
    required this.refSellingPrice,
    required this.minStockLevel,
  });
}
