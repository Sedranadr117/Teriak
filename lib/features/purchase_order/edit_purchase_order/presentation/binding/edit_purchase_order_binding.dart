import 'package:get/get.dart';
import 'package:teriak/features/master_product/presentation/controller/get_allProduct_controller.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/presentation/controller/add_purchase_order_controller.dart';
import 'package:teriak/features/purchase_order/edit_purchase_order/presentation/controller/edit_purchase_order_controller.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/controller/all_supplier_controller.dart';

class EditPurchaseOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GetAllProductController>(GetAllProductController());
    Get.put<GetAllSupplierController>(GetAllSupplierController());
    Get.put<AddPurchaseOrderController>(AddPurchaseOrderController());
    Get.put<EditPurchaseOrderController>(EditPurchaseOrderController());
  }
}
