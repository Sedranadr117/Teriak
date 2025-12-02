
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/localization/app_translations.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/routes/app_routes.dart';
import 'package:teriak/config/themes/app_theme.dart';
import 'package:teriak/config/themes/theme_controller.dart';
import 'package:teriak/core/initializer/app_initializer.dart';


String? role;
Future<void> main() async {
  await AppInitializer.init();
  runApp(
    AppInitializer.runAppWithSizer(const MyApp()),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) => Obx(() => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(context),
            darkTheme: AppTheme.darkTheme(context),
            themeMode: themeController.themeMode,
            locale: LocaleController.to.locale,
            translations: AppTranslations(),
            initialRoute: AppPages.splash,
            getPages: AppRoutes.routes,
          )),
    );
  }
}
