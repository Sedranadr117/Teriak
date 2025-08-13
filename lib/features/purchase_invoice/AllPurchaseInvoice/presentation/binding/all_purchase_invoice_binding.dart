import 'package:get/get.dart';
import '../controller/all_purchase_invoice_controller.dart';

class AllPurchaseInvoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AllPurchaseInvoiceController());
  }
}
