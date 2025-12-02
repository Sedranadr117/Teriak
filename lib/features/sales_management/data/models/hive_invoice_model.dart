import 'package:hive/hive.dart';
import 'package:teriak/core/params/params.dart';

part 'hive_invoice_model.g.dart';

@HiveType(typeId: 0)
class HiveSaleInvoice extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int? customerId;

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
    this.customerId,
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

  /// Creates a HiveSaleInvoice from SaleProcessParams for offline storage
  ///
  /// **Important Notes:**
  /// - The generated ID is TEMPORARY and only used for local Hive storage
  /// - When syncing to backend, the backend will assign a new ID
  /// - This ID is used as the Hive key to store/retrieve the invoice
  /// - ID must be within 32-bit range (0 - 0xFFFFFFFF) for Hive compatibility
  ///
  /// **ID Generation:**
  /// - Combines timestamp + customer ID + items count for uniqueness
  /// - Uses hash function to ensure valid 32-bit integer
  /// - Stored in Hive with: `saleBox.put(invoiceId, invoice)`
  ///
  /// **When Syncing:**
  /// - Invoice is converted back to SaleProcessParams (without ID)
  /// - Backend creates sale and assigns its own ID
  /// - Offline invoice is deleted after successful sync
  static HiveSaleInvoice fromSaleParams(
    SaleProcessParams params, {
    Map<int, String>? productNames,
  }) {
    // Generate a unique 32-bit ID that fits Hive's integer key limit (0 - 0xFFFFFFFF)
    // This ID is ONLY for local Hive storage - backend will assign real ID on sync
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final customerId =
        params.customerId ?? 0; // Use 0 for hash calculation only
    final itemsCount = params.items.length;

    // Create a hash using bitwise operations for better distribution
    // This reduces collision probability while staying within 32-bit range
    var hash = timestamp;
    hash = ((hash << 5) - hash) + customerId; // hash * 31 + customerId
    hash = ((hash << 5) - hash) + itemsCount; // hash * 31 + itemsCount
    hash = hash ^ (hash >> 16); // XOR with upper bits for better distribution

    // Ensure it's positive and within valid range (1 to 0xFFFFFFFF)
    // This ID will be used as: saleBox.put(invoiceId, invoice)
    final invoiceId = (hash.abs() % 0xFFFFFFFF).clamp(1, 0xFFFFFFFF);

    int itemCounter = 0; // To ensure unique item IDs

    final items = params.items.map((item) {
      // Generate item ID within 32-bit range
      final itemHash = ((invoiceId * 1000 + itemCounter++) % 0xFFFFFFFF);
      final itemId = itemHash.abs().clamp(1, 0xFFFFFFFF);
      return HiveSaleItem(
        id: itemId,
        productId: item.stockItemId,
        productName: productNames?[item.stockItemId] ??
            "Product ${item.stockItemId}", // Fallback if name not found
        quantity: item.quantity,
        refundedQuantity: 0,
        availableForRefund: item.quantity,
        unitPrice: item.unitPrice,
        subTotal: item.quantity * item.unitPrice,
      );
    }).toList();

    return HiveSaleInvoice(
      id: invoiceId,
      customerId: params.customerId, // Keep null if no customer selected
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
