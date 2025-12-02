import 'package:hive/hive.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/product_item_model.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/product_item_entity.dart';

part 'hive_product_item_model.g.dart';

@HiveType(typeId: 9)
class HiveProductItemModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final String barcode;

  @HiveField(5)
  final int productId;

  @HiveField(6)
  final String productType;

  @HiveField(7)
  final double? refSellingPrice;

  @HiveField(8)
  final int? minStockLevel;

  HiveProductItemModel({
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

  factory HiveProductItemModel.fromProductItemModel(ProductItemModel model) {
    return HiveProductItemModel(
      id: model.id,
      productName: model.productName,
      quantity: model.quantity,
      price: model.price,
      barcode: model.barcode,
      productId: model.productId,
      productType: model.productType,
      refSellingPrice: model.refSellingPrice,
      minStockLevel: model.minStockLevel,
    );
  }

  ProductItemEntity toEntity() {
    return ProductItemEntity(
      id: id,
      productName: productName,
      quantity: quantity,
      price: price,
      barcode: barcode,
      productId: productId,
      productType: productType,
      refSellingPrice: refSellingPrice,
      minStockLevel: minStockLevel,
    );
  }
}

