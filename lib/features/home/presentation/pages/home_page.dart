import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/config/themes/theme_controller.dart';
import 'package:teriak/core/themes/app_assets.dart';
import 'package:teriak/features/home/presentation/widgets/custom_bottom_nav.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/features/products/all_products/presentation/pages/all_product/all_product_page.dart';
import 'package:teriak/features/purchase_invoice/AllPurchaseInvoice/presentation/pages/all_purchase_invoice_screen.dart';

import 'package:teriak/features/sales_management/presentation/pages/multi_sales_screen.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/presentation/pages/purchase_order_list.dart';
import 'package:teriak/features/stock_management/presentation/pages/stock_management.dart';

import 'package:teriak/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 2);
    _controller.addListener(() {
      setState(() {});
    });
  }

  List<Widget> _buildScreens() {
    final screns = [
      AllProductPage(),
      StockManagement(),
      MultiSalesScreen(),
    ];
    if (role != "PHARMACY_TRAINEE") {
      screns.add(PurchaseOrderList());
    }
    if (role != "PHARMACY_TRAINEE") {
      screns.add(AllPurchaseInvoiceScreen());
    }

    return screns;
  }

  List<String> appBarTitle = [
    "Pharmacy Product".tr,
    "Stock Management".tr,
    "Point of Sale".tr,
    "Purchase Orders Management".tr,
    'Purchase Invoice Management'.tr,
  ];
  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: AppColors.primaryLight),
                child: Stack(
                  children: [
                    Image.asset(
                      Assets.assetsImagesJustLogo,
                      height: 10,
                      width: 10,
                      scale: 10,
                    ),
                    Obx(() => IconButton(
                          onPressed: () => themeController.toggleTheme(),
                          icon: CustomIconWidget(
                            iconName: themeController.isDarkMode
                                ? 'light_mode'
                                : 'dark_mode',
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 24,
                          ),
                          tooltip: themeController.isDarkMode
                              ? 'Switch to Light Mode'
                              : 'Switch to Dark Mode',
                        )),
                  ],
                )),
            role == "PHARMACY_MANAGER"
                ? ListTile(
                    leading: const Icon(Icons.people),
                    title: Text("Employees Management".tr),
                    onTap: () {
                      Get.toNamed(AppPages.employeeManagement);
                    },
                  )
                : SizedBox(),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: Text("Sales Invoices".tr),
              onTap: () {
                Get.toNamed(AppPages.showInvoices);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text("Customers Management".tr),
              onTap: () {
                Get.toNamed(AppPages.indebtedManagement);
              },
            ),
            ListTile(
              leading: const Icon(Icons.undo_rounded),
              title: Text("Returned sales invoices".tr),
              onTap: () {
                Get.toNamed(AppPages.refundsList);
              },
            ),
            role == "PHARMACY_TRAINEE"
                ? SizedBox()
                : ListTile(
                    leading: const Icon(Icons.person_add_alt_1_rounded),
                    title: Text("Suppliers".tr),
                    onTap: () {
                      Get.toNamed(AppPages.supplierList);
                    },
                  ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text("Settings".tr),
              onTap: () {
                Get.toNamed(AppPages.settings);
              },
            ),
            SizedBox(
              height: 25.h,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text("Sign out".tr),
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text(
                            'Sign Out'.tr,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          content: Text(
                            'Are you sure you want to sign out? You will need to sign in again to access your account.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'.tr),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final cacheHelper = CacheHelper();
                                await cacheHelper.removeData(key: 'token');
                                Get.offAllNamed(AppPages.signin);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Signed out successfully'.tr)),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.errorLight,
                                foregroundColor: AppColors.onErrorLight,
                              ),
                              child: Text('Sign Out'.tr),
                            ),
                          ],
                        ));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: appBarTitle[_controller.index].tr == "Point of Sale".tr
            ? true
            : false,
        title: Text(appBarTitle[_controller.index].tr,
            style: appBarTitle[_controller.index].tr == "Point of Sale".tr
                ? Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: AppColors.backgroundLight)
                : Theme.of(context).textTheme.titleLarge),
        backgroundColor: appBarTitle[_controller.index].tr == "Point of Sale".tr
            ? Theme.of(context).colorScheme.primary
            : null,
      ),
      body: CustomBottomNav(
        onTabChanged: (index) {},
        controller: _controller,
        screens: _buildScreens(),
      ),
    );
  }
}
