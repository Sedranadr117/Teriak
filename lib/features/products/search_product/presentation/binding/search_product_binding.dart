import 'package:get/get.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/controller/all_supplier_controller.dart';

class SearchProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GetAllSupplierController>(GetAllSupplierController(),permanent: true);
  }
}
