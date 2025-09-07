import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/main.dart';

class CustomBottomNav extends StatefulWidget {
  final PersistentTabController controller;
  final List<Widget> screens;
  final void Function(int) onTabChanged;

  const CustomBottomNav({
    super.key,
    required this.controller,
    required this.screens,
    required this.onTabChanged,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  late final VoidCallback _controllerListener;

  @override
  void initState() {
    super.initState();
    _controllerListener = () {
      // أي تغيّر بالـ index من المكتبة أو من خارجها رح يمر من هون
      widget.onTabChanged(widget.controller.index);
      setState(() {}); // تحديث الواجهة (وبالتالي الـ AppBar عندك)
    };
    widget.controller.addListener(_controllerListener);
  }

  @override
  void didUpdateWidget(covariant CustomBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    // لو تغيّر الكونترولر المرجعي، نحدّث السماع
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_controllerListener);
      widget.controller.addListener(_controllerListener);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    super.dispose();
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    // للتشخيص فقط
    // print("role = $role");

    final items = <PersistentBottomNavBarItem>[
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.inventory),
        title: ("Stock".tr),
        activeColorPrimary: AppColors.primaryLight,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.point_of_sale),
        title: ("POS".tr),
        activeColorPrimary: AppColors.primaryLight,
        inactiveColorPrimary: Colors.grey,
      ),
    ];

    if (role != "PHARMACY_TRAINEE") {
      items.addAll([
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.monetization_on),
          title: ("Money Box".tr),
          activeColorPrimary: AppColors.primaryLight,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.shopping_cart),
          title: ("Purchase Order".tr),
          activeColorPrimary: AppColors.primaryLight,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.receipt),
          title: ("Invoices".tr),
          activeColorPrimary: AppColors.primaryLight,
          inactiveColorPrimary: Colors.grey,
        ),
      ]);
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context, // ✅ مهم: لازم تكون كمُعامل مُسمّى
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(10),
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
      ),
      confineToSafeArea: true,
      controller: widget.controller,
      screens: widget.screens,
      items: _navBarsItems(),
      navBarStyle: NavBarStyle.style1,
      onItemSelected: (index) {
        if (index < widget.screens.length &&
            widget.controller.index != index) {
          widget.controller.index = index; // رح يطلق الـ listener تلقائيًا
          // widget.onTabChanged(index); // غير ضروري لأن الـ listener عم يناديه
        }
      },
    );
  }
}
