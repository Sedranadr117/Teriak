import 'package:hive/hive.dart';
import 'package:teriak/features/sales_management/data/models/hive_invoice_model.dart';

class LocalSaleDataSourceImpl {
  final Box<HiveSaleInvoice> saleBox;

  LocalSaleDataSourceImpl({required this.saleBox});

  Future<bool> addInvoice(HiveSaleInvoice invoice) async {
    try {
      await saleBox.put(invoice.id, invoice);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Future<List<HiveSaleInvoice>> getAllInvoices() async {
  //   return saleBox.values.toList();
  // }

  // Future<void> deleteInvoice(int id) async {
  //   final invoice = saleBox.values.firstWhere((inv) => inv.id == id);
  //   await invoice.delete();
  // }

  // Future<void> updateInvoice(HiveSaleInvoice invoice) async {
  //   // لازم يكون موجود already بالـ box
  //   final key = saleBox.values.toList().indexWhere((inv) => inv.id == invoice.id);
  //   if (key != -1) {
  //     await saleBox.putAt(key, invoice);
  //   }
  // }
}
