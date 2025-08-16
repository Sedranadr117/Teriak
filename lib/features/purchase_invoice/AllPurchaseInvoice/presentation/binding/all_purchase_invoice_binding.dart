import 'package:get/get.dart';
import '../../../../purchase_order/all_purchase_orders/presentation/controller/all_purchase_order_controller.dart';

class AllPurchaseInvoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GetAllPurchaseOrderController());
  }
}
