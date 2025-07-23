import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/localization/app_translations.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/routes/app_routes.dart';
import 'package:teriak/config/themes/app_theme.dart';
import 'package:teriak/config/themes/theme_controller.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cacheHelper = CacheHelper();
  await cacheHelper.init();
  await NominatimGeocoding.init(reqCacheNum: 20);

  Get.put(ThemeController());
  Get.put(LocaleController());

  runApp(
    // DevicePreview(
    //   enabled: true,
    //   builder: (context) => Sizer(
    //     builder: (context, orientation, deviceType) => MyApp(),
    //   ),
    // ),
    Sizer(
      builder: (context, orientation, deviceType) => MyApp(),
    ),
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
