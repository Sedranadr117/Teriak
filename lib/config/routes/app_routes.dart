import 'package:get/get.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/features/Sales%20management/presentation/pages/multi_sales_screen.dart';
import 'package:teriak/features/Sales%20management/presentation/pages/product_search_screen.dart';
import 'package:teriak/features/auth/presentation/pages/signIn_screen.dart';
import 'package:teriak/features/employee_management/presentation/pages/employee_detail_screen.dart';
import 'package:teriak/features/employee_management/presentation/bindinga/employee_management_binding.dart';
import 'package:teriak/features/employee_management/presentation/pages/add_new_employee_screen.dart';
import 'package:teriak/features/employee_management/presentation/pages/employee_management.dart';
import 'package:teriak/features/add_product/presentation/pages/add_product/add_product.dart';
import 'package:teriak/features/edit_product/presentation/pages/edit_product/edit_product.dart';
import 'package:teriak/features/employee_management/presentation/pages/working_hours_configuration_screen.dart';
import 'package:teriak/features/indebted_management/presentation/pages/add_new_indebted_customer.dart';
import 'package:teriak/features/indebted_management/presentation/pages/indebted_customers_management.dart';
import 'package:teriak/features/inventory_management/inventory_management.dart';
import 'package:teriak/features/pharmacy/presentation/pages/pharmacy_complete_registration.dart';
import 'package:teriak/features/purchase/add_purchase_order/presentation/pages/create_purchase_order.dart';
import 'package:teriak/features/purchase/all_purchase_orders/presentation/pages/purchase_order_list.dart';
import 'package:teriak/features/purchase/edit_purchase_order/presentation/pages/edit_purchase_order.dart';
import 'package:teriak/features/purchase/purchase_order_deatails/presentation/pages/purchase_order_detail.dart';
import 'package:teriak/features/settings/settings.dart';
import 'package:teriak/features/splash/presentation/pages/splash_screen.dart';
import 'package:teriak/features/suppliers/add_supplier/presentation/pages/add_supplier_screen.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/pages/supplier_list_screen.dart';
import 'package:teriak/features/suppliers/details_supplier/presentation/pages/supplier_detail_screen.dart';
import 'package:teriak/features/suppliers/edit_supplier/presentation/pages/edit_supplier_screen.dart';
import 'package:teriak/features/template/presentation/pages/template_screen.dart';
import 'package:teriak/features/master_product/presentation/pages/all_product/all_product_page.dart';
import 'package:teriak/features/product_details/presentation/pages/product_details/product_details_page.dart';

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
      name: AppPages.addNewIndebtedCustomer,
      page: () => const AddNewIndebtedCustomer(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.indebtedManagement,
      page: () => const IndebtedCustomersManagement(),
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
    GetPage(
      name: AppPages.addProductPage,
      page: () => AddProductPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.editProductPage,
      page: () =>  EditProductPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.editSupplier,
      page: () =>  EditSupplierScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.addSupplier,
      page: () =>  AddSupplierScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.supplierDetail,
      page: () =>  SupplierDetailScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.supplierList,
      page: () =>  SupplierListScreen(),
      transition: Transition.fadeIn,
    ),
      GetPage(
      name: AppPages.createPurchaseOrder,
      page: () => CreatePurchaseOrder(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.editPurchaseOrder,
      page: () => EditPurchaseOrder(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.purchaseOrderDetail,
      page: () => PurchaseOrderDetail(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppPages.purchaseOrderList,
      page: () => PurchaseOrderList(),
      transition: Transition.fadeIn,
    ),
  ];
}

class CreatePurchaseOrderScreen {
}
