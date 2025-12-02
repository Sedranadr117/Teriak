// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_pending_purchase_order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HivePendingPurchaseOrderModelAdapter
    extends TypeAdapter<HivePendingPurchaseOrderModel> {
  @override
  final int typeId = 11;

  @override
  HivePendingPurchaseOrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HivePendingPurchaseOrderModel(
      id: fields[0] as int,
      languageCode: fields[1] as String,
      body: (fields[2] as Map).cast<String, dynamic>(),
      createdAt: fields[3] as String,
      status: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HivePendingPurchaseOrderModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.languageCode)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HivePendingPurchaseOrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
