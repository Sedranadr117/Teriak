import 'package:get/get.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/features/Sales%20management/presentation/pages/multi_sales_screen.dart';
import 'package:teriak/features/Sales%20management/presentation/pages/product_search_screen.dart';
import 'package:teriak/features/auth/presentation/pages/signIn_screen.dart';
import 'package:teriak/features/employee_management/presentation/pages/employee_detail_screen.dart';
import 'package:teriak/features/employee_management/presentation/bindinga/employee_management_binding.dart';
import 'package:teriak/features/employee_management/presentation/pages/add_new_employee_screen.dart';
import 'package:teriak/features/employee_management/presentation/pages/employee_management.dart';
import 'package:teriak/features/employee_management/presentation/pages/working_hours_configuration_screen.dart';
import 'package:teriak/features/inventory_management/inventory_management.dart';
import 'package:teriak/features/pharmacy/presentation/pages/pharmacy_complete_registration.dart';
import 'package:teriak/features/settings/settings.dart';
import 'package:teriak/features/splash/presentation/pages/splash_screen.dart';
import 'package:teriak/features/template/presentation/pages/template_screen.dart';
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
      name: AppPages.splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.signin,
      page: () => const SigninScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.multiSales,
      page: () => MultiSalesScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.inventoryManagement,
      page: () => InventoryManagement(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.productSearch,
      page: () => const ProductSearchScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.pharmacyCompleteRegistration,
      page: () => const PharmacyCompleteRegistration(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.employeeManagement,
      page: () => const EmployeeManagement(),
      transition: Transition.fadeIn,
      binding: EmployeeManagementBinding(),
    ),
    GetPage(
      name: AppPages.settings,
      page: () => const Settings(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.employeeDetail,
      page: () => const EmployeeDetail(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.addEmployee,
      page: () => AddEmployeeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.workingHours,
      page: () => WorkingHoursConfigurationScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.home,
      page: () => const HomePage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.productDetailPage,
      page: () => const ProductDetailPage(),
      transition: Transition.fadeIn,
    ),
  ];
}
