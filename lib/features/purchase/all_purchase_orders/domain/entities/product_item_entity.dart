class ProductItemEntity {
  final int id;
  final String productName;
  final int quantity;
  final double price;
  final String barcode;
  final int productId;
  final String productType;

  const ProductItemEntity({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.barcode,
    required this.productId,
    required this.productType,
  });
}
