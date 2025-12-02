// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_product_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveProductItemModelAdapter extends TypeAdapter<HiveProductItemModel> {
  @override
  final int typeId = 9;

  @override
  HiveProductItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveProductItemModel(
      id: fields[0] as int,
      productName: fields[1] as String,
      quantity: fields[2] as int,
      price: fields[3] as double,
      barcode: fields[4] as String,
      productId: fields[5] as int,
      productType: fields[6] as String,
      refSellingPrice: fields[7] as double?,
      minStockLevel: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveProductItemModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.barcode)
      ..writeByte(5)
      ..write(obj.productId)
      ..writeByte(6)
      ..write(obj.productType)
      ..writeByte(7)
      ..write(obj.refSellingPrice)
      ..writeByte(8)
      ..write(obj.minStockLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveProductItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
