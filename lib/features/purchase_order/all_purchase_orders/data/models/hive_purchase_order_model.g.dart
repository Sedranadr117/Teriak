// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_purchase_order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HivePurchaseOrderModelAdapter
    extends TypeAdapter<HivePurchaseOrderModel> {
  @override
  final int typeId = 10;

  @override
  HivePurchaseOrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HivePurchaseOrderModel(
      id: fields[0] as int,
      supplierId: fields[1] as int,
      supplierName: fields[2] as String,
      currency: fields[3] as String,
      total: fields[4] as double,
      status: fields[5] as String,
      createdAt: (fields[6] as List).cast<int>(),
      items: (fields[7] as List).cast<HiveProductItemModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, HivePurchaseOrderModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.supplierId)
      ..writeByte(2)
      ..write(obj.supplierName)
      ..writeByte(3)
      ..write(obj.currency)
      ..writeByte(4)
      ..write(obj.total)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HivePurchaseOrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
