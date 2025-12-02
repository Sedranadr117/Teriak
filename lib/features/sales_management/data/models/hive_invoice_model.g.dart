// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_invoice_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveSaleInvoiceAdapter extends TypeAdapter<HiveSaleInvoice> {
  @override
  final int typeId = 0;

  @override
  HiveSaleInvoice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveSaleInvoice(
      id: fields[0] as int,
      customerId: fields[1] as int?,
      customerName: fields[2] as String,
      invoiceDate: fields[3] as String,
      totalAmount: fields[4] as double,
      paymentType: fields[5] as String,
      paymentMethod: fields[6] as String,
      currency: fields[7] as String,
      discount: fields[8] as double,
      discountType: fields[9] as String,
      paidAmount: fields[10] as double,
      remainingAmount: fields[11] as double,
      status: fields[12] as String,
      paymentStatus: fields[13] as String,
      refundStatus: fields[14] as String,
      debtDueDate: fields[15] as String?,
      items: (fields[16] as List).cast<HiveSaleItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, HiveSaleInvoice obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customerId)
      ..writeByte(2)
      ..write(obj.customerName)
      ..writeByte(3)
      ..write(obj.invoiceDate)
      ..writeByte(4)
      ..write(obj.totalAmount)
      ..writeByte(5)
      ..write(obj.paymentType)
      ..writeByte(6)
      ..write(obj.paymentMethod)
      ..writeByte(7)
      ..write(obj.currency)
      ..writeByte(8)
      ..write(obj.discount)
      ..writeByte(9)
      ..write(obj.discountType)
      ..writeByte(10)
      ..write(obj.paidAmount)
      ..writeByte(11)
      ..write(obj.remainingAmount)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.paymentStatus)
      ..writeByte(14)
      ..write(obj.refundStatus)
      ..writeByte(15)
      ..write(obj.debtDueDate)
      ..writeByte(16)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveSaleInvoiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveSaleItemAdapter extends TypeAdapter<HiveSaleItem> {
  @override
  final int typeId = 1;

  @override
  HiveSaleItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveSaleItem(
      id: fields[0] as int,
      productId: fields[1] as int,
      productName: fields[2] as String,
      quantity: fields[3] as int,
      refundedQuantity: fields[4] as int,
      availableForRefund: fields[5] as int,
      unitPrice: fields[6] as double,
      subTotal: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, HiveSaleItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.productName)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.refundedQuantity)
      ..writeByte(5)
      ..write(obj.availableForRefund)
      ..writeByte(6)
      ..write(obj.unitPrice)
      ..writeByte(7)
      ..write(obj.subTotal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveSaleItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
