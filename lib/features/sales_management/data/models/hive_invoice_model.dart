import 'package:hive/hive.dart';
import 'package:teriak/core/params/params.dart';

part 'hive_invoice_model.g.dart';

@HiveType(typeId: 0)
class HiveSaleInvoice extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int customerId;

  @HiveField(2)
  final String customerName;

  @HiveField(3)
  final String invoiceDate;

  @HiveField(4)
  final double totalAmount;

  @HiveField(5)
  final String paymentType;

  @HiveField(6)
  final String paymentMethod;

  @HiveField(7)
  final String currency;

  @HiveField(8)
  final double discount;

  @HiveField(9)
  final String discountType;

  @HiveField(10)
  final double paidAmount;

  @HiveField(11)
  final double remainingAmount;

  @HiveField(12)
  final String status;

  @HiveField(13)
  final String paymentStatus;

  @HiveField(14)
  final String refundStatus;

  @HiveField(15)
  final String? debtDueDate;

  @HiveField(16)
  final List<HiveSaleItem> items;

  HiveSaleInvoice({
    required this.id,
    required this.customerId,
    this.customerName = '',
    required this.invoiceDate,
    required this.totalAmount,
    required this.paymentType,
    required this.paymentMethod,
    required this.currency,
    required this.discount,
    required this.discountType,
    required this.paidAmount,
    required this.remainingAmount,
    required this.status,
    required this.paymentStatus,
    required this.refundStatus,
    this.debtDueDate,
    required this.items,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'invoiceDate': invoiceDate,
      'totalAmount': totalAmount,
      'paymentType': paymentType,
      'paymentMethod': paymentMethod,
      'currency': currency,
      'discount': discount,
      'discountType': discountType,
      'paidAmount': paidAmount,
      'remainingAmount': remainingAmount,
      'status': status,
      'paymentStatus': paymentStatus,
      'refundStatus': refundStatus,
      'debtDueDate': debtDueDate,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  static HiveSaleInvoice fromSaleParams(SaleProcessParams params) {
    final invoiceId = DateTime.now().millisecondsSinceEpoch;

    final items = params.items.map((item) {
      final itemId = DateTime.now().millisecondsSinceEpoch +
          item.stockItemId; // ضمان عدم التكرار
      return HiveSaleItem(
        id: itemId,
        productId: item.stockItemId,
        productName: "", // ممكن تعدلي حسب توفر الاسم
        quantity: item.quantity,
        refundedQuantity: 0,
        availableForRefund: item.quantity,
        unitPrice: item.unitPrice,
        subTotal: item.quantity * item.unitPrice,
      );
    }).toList();

    return HiveSaleInvoice(
      id: invoiceId,
      customerId: params.customerId ?? 0,
      customerName: "",
      invoiceDate: DateTime.now().toIso8601String(),
      totalAmount: items.fold(0.0, (sum, item) => sum + item.subTotal),
      paymentType: params.paymentType,
      paymentMethod: params.paymentMethod,
      currency: params.currency,
      discount: params.discountValue,
      discountType: params.discountType,
      paidAmount: params.paidAmount ?? 0.0,
      remainingAmount: params.paidAmount ?? 0.0,
      status: 'PENDING',
      paymentStatus: 'UNPAID',
      refundStatus: 'NO_REFUND',
      debtDueDate: params.debtDueDate,
      items: items,
    );
  }
}

@HiveType(typeId: 1)
class HiveSaleItem extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int productId;

  @HiveField(2)
  final String productName;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final int refundedQuantity;

  @HiveField(5)
  final int availableForRefund;

  @HiveField(6)
  final double unitPrice;

  @HiveField(7)
  final double subTotal;

  HiveSaleItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.refundedQuantity,
    required this.availableForRefund,
    required this.unitPrice,
    required this.subTotal,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'refundedQuantity': refundedQuantity,
      'availableForRefund': availableForRefund,
      'unitPrice': unitPrice,
      'subTotal': subTotal,
    };
  }
}
