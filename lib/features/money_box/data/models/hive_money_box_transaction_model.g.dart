// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_money_box_transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveMoneyBoxTransactionModelAdapter
    extends TypeAdapter<HiveMoneyBoxTransactionModel> {
  @override
  final int typeId = 13;

  @override
  HiveMoneyBoxTransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMoneyBoxTransactionModel(
      id: fields[0] as int,
      transactionType: fields[1] as String,
      amount: fields[2] as double,
      balanceBefore: fields[3] as double,
      balanceAfter: fields[4] as double,
      description: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveMoneyBoxTransactionModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.transactionType)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.balanceBefore)
      ..writeByte(4)
      ..write(obj.balanceAfter)
      ..writeByte(5)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMoneyBoxTransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
