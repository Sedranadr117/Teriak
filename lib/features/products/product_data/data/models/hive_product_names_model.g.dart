// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_product_names_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveProductNamesModelAdapter extends TypeAdapter<HiveProductNamesModel> {
  @override
  final int typeId = 7;

  @override
  HiveProductNamesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveProductNamesModel(
      id: fields[0] as int,
      tradeNameAr: fields[1] as String,
      tradeNameEn: fields[2] as String,
      scientificNameAr: fields[3] as String,
      scientificNameEn: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveProductNamesModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tradeNameAr)
      ..writeByte(2)
      ..write(obj.tradeNameEn)
      ..writeByte(3)
      ..write(obj.scientificNameAr)
      ..writeByte(4)
      ..write(obj.scientificNameEn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveProductNamesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
