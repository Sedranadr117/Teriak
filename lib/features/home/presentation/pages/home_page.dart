import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/core/themes/app_assets.dart';
import 'package:teriak/features/home/presentation/widgets/custom_bottom_nav.dart';

import 'package:teriak/features/sales_management/presentation/pages/multi_sales_screen.dart';
import 'package:teriak/features/purchase/all_purchase_orders/presentation/pages/purchase_order_list.dart';
import 'package:teriak/features/stock_management/presentation/pages/stock_management.dart';
import 'package:teriak/features/master_product/presentation/pages/all_product/all_product_page.dart';
import 'package:teriak/purchaseInvoiceList.dart';

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
    return [
      PurchaseOrderList(),
      StockManagement(),
      MultiSalesScreen(),
      AllProductPage(),
      purchaseInvoiceList(),
    ];
  }

  List<String> appBarTitle = [
    "Purchase Orders Management".tr,
    "Stock Management".tr,
    "Point of Sale".tr,
    "Pharmacy Product".tr,
    "Invoices".tr
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: AppColors.primaryLight),
                child: Image.asset(
                  Assets.assetsImagesJustLogo,
                  height: 10,
                  width: 10,
                  scale: 10,
                )),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Employees Management"),
              onTap: () {
                Get.toNamed(AppPages.employeeManagement);
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text("Sale Invoices"),
              onTap: () {
                Get.toNamed(AppPages.showInvoices);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Customers Management"),
              onTap: () {
                Get.toNamed(AppPages.indebtedManagement);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt_1_rounded),
              title: const Text("Suppliers"),
              onTap: () {
                Get.toNamed(AppPages.supplierList);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Get.toNamed(AppPages.settings);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle:
            appBarTitle[_controller.index] == "Point of Sale".tr ? true : false,
        title: Text(appBarTitle[_controller.index],
            style: appBarTitle[_controller.index] == "Point of Sale".tr
                ? Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: AppColors.backgroundLight)
                : Theme.of(context).textTheme.titleLarge),
        backgroundColor: appBarTitle[_controller.index] == "Point of Sale".tr
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
