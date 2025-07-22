import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/routes/app_routes.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/themes/app_theme.dart';
import 'package:teriak/core/themes/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cacheHelper = CacheHelper();
  await cacheHelper.init();
  await NominatimGeocoding.init(reqCacheNum: 20);

  Get.put(ThemeController());

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
      builder: (themeController) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode,
        initialRoute: AppPages.splash,
        getPages: AppRoutes.routes,
      ),
    );
    ////
  }
}
