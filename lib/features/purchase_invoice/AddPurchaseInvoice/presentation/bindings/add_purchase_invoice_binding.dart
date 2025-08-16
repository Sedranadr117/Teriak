import 'package:get/get.dart';
import '../controllers/add_purchase_invoice_controller.dart';

class AddPurchaseInvoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddPurchaseInvoiceController());
    
  }
}
