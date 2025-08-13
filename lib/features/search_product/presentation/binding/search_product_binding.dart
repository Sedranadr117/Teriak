import 'package:get/get.dart';
import 'package:teriak/features/search_product/presentation/controller/search_product_controller.dart';

class SearchProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SearchProductController>(SearchProductController(),
        permanent: true);
  }
}
