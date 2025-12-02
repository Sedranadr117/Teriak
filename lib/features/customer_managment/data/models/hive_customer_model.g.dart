// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_customer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveCustomerModelAdapter extends TypeAdapter<HiveCustomerModel> {
  @override
  final int typeId = 3;

  @override
  HiveCustomerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveCustomerModel(
      id: fields[0] as int,
      name: fields[1] as String,
      phoneNumber: fields[2] as String,
      address: fields[3] as String,
      notes: fields[4] as String?,
      totalDebt: fields[5] as double,
      totalPaid: fields[6] as double,
      remainingDebt: fields[7] as double,
      activeDebtsCount: fields[8] as int,
      debts: (fields[9] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveCustomerModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.totalDebt)
      ..writeByte(6)
      ..write(obj.totalPaid)
      ..writeByte(7)
      ..write(obj.remainingDebt)
      ..writeByte(8)
      ..write(obj.activeDebtsCount)
      ..writeByte(9)
      ..write(obj.debts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveCustomerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
