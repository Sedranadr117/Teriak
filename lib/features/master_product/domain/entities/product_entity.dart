class ProductEntity {
  final int id;
  final String tradeName;
  final String scientificName;
  final List<dynamic>? barcodes;
  final String barcode;
  final String productType;
  final bool requiresPrescription;
  final String concentration;
  final String size;
  final String? type;
  final String form;
  final String? manufacturer;
  final String? notes;
  final List<dynamic>? categories;

  const ProductEntity({
    required this.id,
    required this.tradeName,
    required this.scientificName,
    required this.barcodes,
    required this.barcode,
    required this.productType,
    required this.requiresPrescription,
    required this.concentration,
    required this.size,
    required this.type,
    required this.form,
    required this.manufacturer,
    required this.notes,
    required this.categories,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
