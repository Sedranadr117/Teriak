import 'package:get/get.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/main.dart';

class AppRoutes {
  static final List<GetPage> routes = [
    GetPage(
      name: AppPages.homePage,
      page: () => const MyHomePage(title: 'Flutter Demo Home Page'),
      transition: Transition.fadeIn,
    ),
  ];
}