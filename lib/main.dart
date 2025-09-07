import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/localization/app_translations.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/routes/app_routes.dart';
import 'package:teriak/config/themes/app_theme.dart';
import 'package:teriak/config/themes/theme_controller.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/features/sales_management/data/datasources/sale_local_date_source.dart';
import 'package:teriak/features/sales_management/data/datasources/sale_remote_data_source.dart';
import 'package:teriak/features/sales_management/data/models/hive_invoice_model.dart';
import 'package:teriak/features/sales_management/data/repositories/sale_repository_impl.dart';

String? role;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(HiveSaleInvoiceAdapter());
  Hive.registerAdapter(HiveSaleItemAdapter());

  final saleBox = await Hive.openBox<HiveSaleInvoice>('saleInvoices');
  print("--------------------${Hive.isBoxOpen('saleInvoices')}");
  print(
      '📦 [DEBUG] Hive box "cached_stock" opened. Current items: ${saleBox.values.length}');

  final localDataSource = LocalSaleDataSourceImpl(saleBox: saleBox);
  final cacheHelper = CacheHelper();
  final httpConsumer =
      HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

  final remoteDataSource = SaleRemoteDataSource(api: httpConsumer);
  final networkInfo = NetworkInfoImpl(); // مثال

  final saleRepository = SaleRepositoryImpl(
    localDataSource,
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
  Get.put(saleRepository);

  await cacheHelper.init();
  role = cacheHelper.getData(key: 'Role');

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
