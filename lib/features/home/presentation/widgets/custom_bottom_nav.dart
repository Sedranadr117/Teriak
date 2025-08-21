import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:teriak/config/themes/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final PersistentTabController controller;
  final List<Widget> screens;
  final void Function(dynamic) onTabChanged;
  const CustomBottomNav({
    super.key,
    required this.controller,
    required this.screens,
    required this.onTabChanged,
  });

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.science),
        title: ("Pharmacy Product".tr),
        activeColorPrimary: AppColors.primaryLight,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.inventory),
        title: ("Stock"),
        activeColorPrimary: AppColors.primaryLight,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("POS"),
        activeColorPrimary: AppColors.primaryLight,
        inactiveColorPrimary: Colors.grey,
      ),
      
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_cart),
        title: ("Purchase Order".tr),
        activeColorPrimary: AppColors.primaryLight,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.receipt),
        title: ("Purchase Invoices".tr),
        activeColorPrimary: AppColors.primaryLight,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(10),
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
      ),
      context,
      confineToSafeArea: true,
      controller: controller,
      screens: screens,
      items: _navBarsItems(),
      navBarStyle: NavBarStyle.style1,
      onItemSelected: (index) {
        if (controller.index != index) {
          controller.index = index;
          onTabChanged(index);
        }
      },
    );
  }
}
