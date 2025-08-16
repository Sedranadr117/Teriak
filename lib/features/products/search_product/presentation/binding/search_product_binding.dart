import 'package:get/get.dart';
import 'package:teriak/features/products/search_product/presentation/controller/search_product_controller.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/controller/all_supplier_controller.dart';

class SearchProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SearchProductController>(SearchProductController(),
        permanent: true);
    Get.put<GetAllSupplierController>(GetAllSupplierController(),
        permanent: true);
  }
}
