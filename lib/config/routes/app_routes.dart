import 'package:get/get.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/features/auth/presentation/pages/signIn_screen.dart';
import 'package:teriak/features/employee_management/employee_management.dart';
import 'package:teriak/features/pharmacy/presentation/pages/add_pharmacy.dart';
import 'package:teriak/features/settings/settings.dart';
import 'package:teriak/features/splash/presentation/pages/splash_screen.dart';

class AppRoutes {
  static final List<GetPage> routes = [
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
      name: AppPages.addPharmacy,
      page: () => const AddPharmacy(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.employeeManagement,
      page: () => const EmployeeManagement(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.settings,
      page: () => const Settings(),
      transition: Transition.fadeIn,
    ),
  ];
}
