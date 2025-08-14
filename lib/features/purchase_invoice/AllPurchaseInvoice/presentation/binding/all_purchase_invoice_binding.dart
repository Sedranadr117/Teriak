import 'package:get/get.dart';
import '../controller/all_purchase_invoice_controller.dart';
import '../../../../purchase_order/all_purchase_orders/presentation/controller/all_purchase_order_controller.dart';

class AllPurchaseInvoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AllPurchaseInvoiceController());
    Get.put(GetAllPurchaseOrderController());
  }
}
