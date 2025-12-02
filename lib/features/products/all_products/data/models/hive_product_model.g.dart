// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveProductModelAdapter extends TypeAdapter<HiveProductModel> {
  @override
  final int typeId = 4;

  @override
  HiveProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveProductModel(
      id: fields[0] as int,
      tradeName: fields[1] as String,
      scientificName: fields[2] as String,
      barcodes: (fields[3] as List).cast<String>(),
      barcode: fields[4] as String,
      productType: fields[5] as String,
      requiresPrescription: fields[6] as bool,
      concentration: fields[7] as String,
      size: fields[8] as String,
      type: fields[9] as String?,
      form: fields[10] as String,
      manufacturer: fields[11] as String?,
      notes: fields[12] as String?,
      refPurchasePrice: fields[13] as double,
      refSellingPrice: fields[14] as double,
      refPurchasePriceUSD: fields[15] as double,
      refSellingPriceUSD: fields[16] as double,
      minStockLevel: fields[17] as int?,
      quantity: fields[18] as int,
      categories: (fields[19] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveProductModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tradeName)
      ..writeByte(2)
      ..write(obj.scientificName)
      ..writeByte(3)
      ..write(obj.barcodes)
      ..writeByte(4)
      ..write(obj.barcode)
      ..writeByte(5)
      ..write(obj.productType)
      ..writeByte(6)
      ..write(obj.requiresPrescription)
      ..writeByte(7)
      ..write(obj.concentration)
      ..writeByte(8)
      ..write(obj.size)
      ..writeByte(9)
      ..write(obj.type)
      ..writeByte(10)
      ..write(obj.form)
      ..writeByte(11)
      ..write(obj.manufacturer)
      ..writeByte(12)
      ..write(obj.notes)
      ..writeByte(13)
      ..write(obj.refPurchasePrice)
      ..writeByte(14)
      ..write(obj.refSellingPrice)
      ..writeByte(15)
      ..write(obj.refPurchasePriceUSD)
      ..writeByte(16)
      ..write(obj.refSellingPriceUSD)
      ..writeByte(17)
      ..write(obj.minStockLevel)
      ..writeByte(18)
      ..write(obj.quantity)
      ..writeByte(19)
      ..write(obj.categories);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
