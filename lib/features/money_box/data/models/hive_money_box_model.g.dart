// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_money_box_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveMoneyBoxModelAdapter extends TypeAdapter<HiveMoneyBoxModel> {
  @override
  final int typeId = 12;

  @override
  HiveMoneyBoxModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMoneyBoxModel(
      id: fields[0] as int,
      status: fields[1] as String,
      lastReconciled: (fields[2] as List).cast<int>(),
      totalBalanceInSYP: fields[3] as double,
      totalBalanceInUSD: fields[4] as double,
      currentUSDToSYPRate: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveMoneyBoxModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.lastReconciled)
      ..writeByte(3)
      ..write(obj.totalBalanceInSYP)
      ..writeByte(4)
      ..write(obj.totalBalanceInUSD)
      ..writeByte(5)
      ..write(obj.currentUSDToSYPRate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMoneyBoxModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
