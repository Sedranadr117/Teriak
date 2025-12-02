import 'package:hive/hive.dart';
import 'package:teriak/features/sales_management/data/models/hive_invoice_model.dart';
import 'package:teriak/features/sales_management/data/models/invoice_model.dart';
import 'package:teriak/features/sales_management/domain/entities/invoice_entity.dart';

class LocalSaleDataSourceImpl {
  final Box<HiveSaleInvoice> saleBox;

  LocalSaleDataSourceImpl({required this.saleBox});

  /// Saves an offline invoice to Hive storage
  ///
  /// **How it works:**
  /// - Uses `invoice.id` as the Hive key: `saleBox.put(invoice.id, invoice)`
  /// - The ID is a temporary 32-bit integer generated locally
  /// - When syncing to backend, backend assigns a new ID and this offline invoice is deleted
  ///
  /// **Storage:**
  /// - Invoice stored in Hive box: `saleInvoices`
  /// - Key: `invoice.id` (temporary local ID)
  /// - Value: `HiveSaleInvoice` object
  Future<bool> addInvoice(HiveSaleInvoice invoice) async {
    try {
      print('💾 Attempting to save invoice with ID: ${invoice.id}');
      print(
          '📋 Invoice details: customerId=${invoice.customerId}, items=${invoice.items.length}');

      // Validate invoice data
      if (invoice.id <= 0) {
        print('❌ Invalid invoice ID: ${invoice.id}');
        return false;
      }

      if (invoice.items.isEmpty) {
        print('❌ Invoice has no items');
        return false;
      }

      // Store in Hive: invoice.id is the key, invoice is the value
      // This ID is temporary - backend will assign real ID when syncing
      await saleBox.put(invoice.id, invoice);
      print('✅ Invoice saved successfully with ID: ${invoice.id}');
      return true;
    } catch (e, stackTrace) {
      print('❌ Error saving invoice to Hive: $e');
      print('📚 Stack trace: $stackTrace');
      return false;
    }
  }

  Future<void> cacheInvoices(List<InvoiceModel> invoices) async {
    final hiveInvoices = invoices.map(_mapInvoiceModelToHive).toList();
    await saleBox.clear();
    await saleBox.addAll(hiveInvoices);
  }

  Future<void> upsertInvoice(InvoiceModel invoice) async {
    await saleBox.put(invoice.id, _mapInvoiceModelToHive(invoice));
  }

  List<InvoiceModel> getInvoices() {
    return saleBox.values
        .map((invoice) => InvoiceModel.fromHiveInvoice(invoice))
        .toList();
  }

  List<InvoiceModel> searchInvoicesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    return saleBox.values
        .where((invoice) {
          final parsedDate = DateTime.tryParse(invoice.invoiceDate);
          if (parsedDate == null) return false;
          return !parsedDate.isBefore(startDate) &&
              !parsedDate.isAfter(endDate);
        })
        .map(InvoiceModel.fromHiveInvoice)
        .toList();
  }

  /// Get all offline invoices (those with status 'PENDING' or timestamp-based IDs)
  List<InvoiceModel> getOfflineInvoices() {
    return saleBox.values
        .where((invoice) => _isOfflineInvoice(invoice))
        .map(InvoiceModel.fromHiveInvoice)
        .toList();
  }

  /// Get count of offline invoices
  int getOfflineInvoicesCount() {
    return saleBox.values.where((invoice) => _isOfflineInvoice(invoice)).length;
  }

  /// Check if an invoice is offline (created offline)
  bool _isOfflineInvoice(HiveSaleInvoice invoice) {
    // Offline invoices have status 'PENDING' and timestamp-based IDs
    // Timestamp-based IDs are typically > 1e12 (milliseconds since epoch)
    final isTimestampBasedId = invoice.id > 1000000000000;
    final isPendingStatus = invoice.status == 'PENDING';
    return isPendingStatus || isTimestampBasedId;
  }

  /// Get a specific offline invoice by ID
  InvoiceModel? getOfflineInvoiceById(int id) {
    try {
      final invoice = saleBox.get(id);
      if (invoice != null && _isOfflineInvoice(invoice)) {
        return InvoiceModel.fromHiveInvoice(invoice);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Delete an offline invoice
  Future<bool> deleteOfflineInvoice(int id) async {
    try {
      await saleBox.delete(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Clear all offline invoices
  Future<void> clearOfflineInvoices() async {
    final offlineIds = saleBox.values
        .where((invoice) => _isOfflineInvoice(invoice))
        .map((invoice) => invoice.id)
        .toList();
    await saleBox.deleteAll(offlineIds);
  }

  HiveSaleInvoice _mapInvoiceModelToHive(InvoiceEntity invoice) {
    final items = invoice.items
        .map((item) => HiveSaleItem(
              id: item.id,
              productId: item.stockItemId,
              productName: item.productName,
              quantity: item.quantity,
              refundedQuantity: item.refundedQuantity,
              availableForRefund: item.availableForRefund,
              unitPrice: item.unitPrice,
              subTotal: item.subTotal,
            ))
        .toList();

    return HiveSaleInvoice(
      id: invoice.id,
      customerId: invoice.customerId,
      customerName: invoice.customerName,
      invoiceDate: invoice.invoiceDate,
      totalAmount: invoice.totalAmount,
      paymentType: invoice.paymentType,
      paymentMethod: invoice.paymentMethod,
      currency: invoice.currency,
      discount: invoice.discount,
      discountType: invoice.discountType,
      paidAmount: invoice.paidAmount,
      remainingAmount: invoice.remainingAmount,
      status: invoice.status,
      paymentStatus: invoice.paymentStatus,
      refundStatus: invoice.refundStatus,
      debtDueDate: invoice.debtDueDate,
      items: items,
    );
  }
}
