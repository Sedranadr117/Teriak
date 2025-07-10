import 'package:get/get.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/features/master_product/presentation/pages/all_product/all_product_page.dart';
import 'package:teriak/features/master_product/presentation/pages/product_details/product_details_page.dart';

class AppRoutes {
  static final List<GetPage> routes = [
    GetPage(
      name: AppPages.allProductPage,
      page: () => const AllProductPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.productDetailPage,
      page: () => const ProductDetailPage(),
      transition: Transition.fadeIn,
    ),
  ];
}
