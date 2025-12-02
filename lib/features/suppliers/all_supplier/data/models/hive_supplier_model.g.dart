// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_supplier_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveSupplierModelAdapter extends TypeAdapter<HiveSupplierModel> {
  @override
  final int typeId = 8;

  @override
  HiveSupplierModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveSupplierModel(
      id: fields[0] as int,
      name: fields[1] as String,
      phone: fields[2] as String,
      address: fields[3] as String,
      preferredCurrency: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveSupplierModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.preferredCurrency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveSupplierModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
