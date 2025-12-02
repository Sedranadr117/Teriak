import 'package:hive/hive.dart';
import 'package:teriak/features/products/all_products/data/models/product_model.dart';
import 'package:teriak/features/products/all_products/domain/entities/product_entity.dart';

part 'hive_product_model.g.dart';

@HiveType(typeId: 4)
class HiveProductModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String tradeName;

  @HiveField(2)
  final String scientificName;

  @HiveField(3)
  final List<String> barcodes;

  @HiveField(4)
  final String barcode;

  @HiveField(5)
  final String productType;

  @HiveField(6)
  final bool requiresPrescription;

  @HiveField(7)
  final String concentration;

  @HiveField(8)
  final String size;

  @HiveField(9)
  final String? type;

  @HiveField(10)
  final String form;

  @HiveField(11)
  final String? manufacturer;

  @HiveField(12)
  final String? notes;

  @HiveField(13)
  final double refPurchasePrice;

  @HiveField(14)
  final double refSellingPrice;

  @HiveField(15)
  final double refPurchasePriceUSD;

  @HiveField(16)
  final double refSellingPriceUSD;

  @HiveField(17)
  final int? minStockLevel;

  @HiveField(18)
  final int quantity;

  @HiveField(19)
  final List<String> categories;

  HiveProductModel({
    required this.id,
    required this.tradeName,
    required this.scientificName,
    required this.barcodes,
    required this.barcode,
    required this.productType,
    required this.requiresPrescription,
    required this.concentration,
    required this.size,
    this.type,
    required this.form,
    this.manufacturer,
    this.notes,
    required this.refPurchasePrice,
    required this.refSellingPrice,
    required this.refPurchasePriceUSD,
    required this.refSellingPriceUSD,
    this.minStockLevel,
    required this.quantity,
    required this.categories,
  });

  factory HiveProductModel.fromProductModel(ProductModel model) {
    return HiveProductModel(
      id: model.id,
      tradeName: model.tradeName,
      scientificName: model.scientificName,
      barcodes: model.barcodes?.map((e) => e.toString()).toList() ?? [],
      barcode: model.barcode,
      productType: model.productType,
      requiresPrescription: model.requiresPrescription,
      concentration: model.concentration,
      size: model.size,
      type: model.type,
      form: model.form,
      manufacturer: model.manufacturer,
      notes: model.notes,
      refPurchasePrice: model.refPurchasePrice,
      refSellingPrice: model.refSellingPrice,
      refPurchasePriceUSD: model.refPurchasePriceUSD,
      refSellingPriceUSD: model.refSellingPriceUSD,
      minStockLevel: model.minStockLevel,
      quantity: model.quantity,
      categories: model.categories?.map((e) => e.toString()).toList() ?? [],
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      tradeName: tradeName,
      scientificName: scientificName,
      barcodes: barcodes,
      barcode: barcode,
      productType: productType,
      requiresPrescription: requiresPrescription,
      concentration: concentration,
      size: size,
      type: type,
      form: form,
      manufacturer: manufacturer,
      notes: notes,
      refPurchasePrice: refPurchasePrice,
      refSellingPrice: refSellingPrice,
      refPurchasePriceUSD: refPurchasePriceUSD,
      refSellingPriceUSD: refSellingPriceUSD,
      minStockLevel: minStockLevel,
      quantity: quantity,
      categories: categories,
    );
  }

  // Normalize productType to handle Arabic/English variations
  String get _normalizedProductType {
    final normalized = productType.toLowerCase().trim();
    if (normalized == 'صيدلية' || normalized == 'pharmacy') {
      return 'pharmacy';
    } else if (normalized == 'مركزي' || normalized == 'master') {
      return 'master';
    }
    return normalized;
  }

  // Generate a unique key for caching (id + normalized productType)
  String get cacheKey => '${id}_${_normalizedProductType}';

  // Alternative key using barcode for deduplication
  // Only use barcode for deduplication if it's not empty or just whitespace
  String get barcodeKey {
    final trimmedBarcode = barcode.trim();
    return trimmedBarcode.isNotEmpty ? 'barcode_$trimmedBarcode' : '';
  }
}
