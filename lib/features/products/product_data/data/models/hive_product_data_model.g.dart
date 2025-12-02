// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_product_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveProductDataModelAdapter extends TypeAdapter<HiveProductDataModel> {
  @override
  final int typeId = 6;

  @override
  HiveProductDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveProductDataModel(
      id: fields[0] as int,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveProductDataModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveProductDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
