
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/features/purchase/all_purchase_orders/domain/entities/product_item_entity.dart';


class ProductItemModel extends ProductItemEntity {
  const ProductItemModel({
    required super.id,
    required super.productName,
    required super.quantity,
    required super.price,
    required super.barcode,
    required super.productId,
    required super.productType,
  });

  factory ProductItemModel.fromJson(Map<String, dynamic> json) {
    return ProductItemModel(
      id: json[ApiKeys.id],
      productName: json[ApiKeys.productItemName],
      quantity: json[ApiKeys.productItemQuantity],
      price: (json[ApiKeys.productItemPrice] as num).toDouble(),
      barcode: json[ApiKeys.barcode],
      productId: json[ApiKeys.productItemId],
      productType: json[ApiKeys.productItemType],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.productItemName: productName,
      ApiKeys.productItemQuantity: quantity,
      ApiKeys.productItemPrice: price,
      ApiKeys.barcode: barcode,
      ApiKeys.productItemId: productId,
      ApiKeys.productItemType: productType,
    };
  }
}
