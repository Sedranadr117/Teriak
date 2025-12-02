// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_stock_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveStockModelAdapter extends TypeAdapter<HiveStockModel> {
  @override
  final int typeId = 2;

  @override
  HiveStockModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveStockModel(
      id: fields[0] as int,
      productId: fields[1] as int,
      productName: fields[2] as String,
      productNameAr: fields[25] as String?,
      productType: fields[3] as String,
      barcodes: (fields[4] as List).cast<String>(),
      totalQuantity: fields[5] as int,
      totalBonusQuantity: fields[6] as int,
      actualPurchasePrice: fields[7] as double,
      totalValue: fields[8] as double,
      categories: (fields[9] as List).cast<String>(),
      sellingPrice: fields[10] as double,
      minStockLevel: fields[11] as int?,
      hasExpiredItems: fields[12] as bool,
      hasExpiringSoonItems: fields[13] as bool,
      earliestExpiryDate: fields[14] as DateTime?,
      latestExpiryDate: fields[15] as DateTime?,
      numberOfBatches: fields[16] as int,
      pharmacyId: fields[17] as int,
      dualCurrencyDisplay: fields[18] as bool,
      actualPurchasePriceUSD: fields[19] as double,
      totalValueUSD: fields[20] as double,
      sellingPriceUSD: fields[21] as double,
      exchangeRateSYPToUSD: fields[22] as double,
      conversionTimestampSYPToUSD: fields[23] as DateTime?,
      rateSource: fields[24] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveStockModel obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.productName)
      ..writeByte(25)
      ..write(obj.productNameAr)
      ..writeByte(3)
      ..write(obj.productType)
      ..writeByte(4)
      ..write(obj.barcodes)
      ..writeByte(5)
      ..write(obj.totalQuantity)
      ..writeByte(6)
      ..write(obj.totalBonusQuantity)
      ..writeByte(7)
      ..write(obj.actualPurchasePrice)
      ..writeByte(8)
      ..write(obj.totalValue)
      ..writeByte(9)
      ..write(obj.categories)
      ..writeByte(10)
      ..write(obj.sellingPrice)
      ..writeByte(11)
      ..write(obj.minStockLevel)
      ..writeByte(12)
      ..write(obj.hasExpiredItems)
      ..writeByte(13)
      ..write(obj.hasExpiringSoonItems)
      ..writeByte(14)
      ..write(obj.earliestExpiryDate)
      ..writeByte(15)
      ..write(obj.latestExpiryDate)
      ..writeByte(16)
      ..write(obj.numberOfBatches)
      ..writeByte(17)
      ..write(obj.pharmacyId)
      ..writeByte(18)
      ..write(obj.dualCurrencyDisplay)
      ..writeByte(19)
      ..write(obj.actualPurchasePriceUSD)
      ..writeByte(20)
      ..write(obj.totalValueUSD)
      ..writeByte(21)
      ..write(obj.sellingPriceUSD)
      ..writeByte(22)
      ..write(obj.exchangeRateSYPToUSD)
      ..writeByte(23)
      ..write(obj.conversionTimestampSYPToUSD)
      ..writeByte(24)
      ..write(obj.rateSource);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveStockModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
