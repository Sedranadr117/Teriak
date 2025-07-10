import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:teriak/config/localization/app_translations.dart';
import 'package:teriak/config/routes/app_routes.dart';
import 'package:teriak/config/themes/app_theme.dart';
import 'package:teriak/features/master_product/presentation/pages/all_product/all_product_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: AppTheme.lightTheme(context),
        darkTheme: AppTheme.darkTheme(context),
        themeMode: ThemeMode.system,
        locale: Get.deviceLocale,
        translations: AppTranslations(),
        home: const AllProductPage(),
        debugShowCheckedModeBanner: false,
        getPages: AppRoutes.routes);
  }
}
