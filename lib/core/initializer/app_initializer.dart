import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/config/themes/theme_controller.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/services/notification_service.dart';
import 'package:teriak/features/notification/presentation/controller/notification_controller.dart';
import 'package:teriak/features/sales_management/data/datasources/sale_local_date_source.dart';
import 'package:teriak/features/sales_management/data/datasources/sale_remote_data_source.dart';
import 'package:teriak/features/sales_management/data/models/hive_invoice_model.dart';
import 'package:teriak/features/sales_management/data/repositories/sale_repository_impl.dart';
import 'package:teriak/main.dart';
import 'package:teriak/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class AppInitializer {

  /// هذا التابع ينفذ كل عمليات التهيئة
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Hive
    await Hive.initFlutter();
    Hive.registerAdapter(HiveSaleInvoiceAdapter());
    Hive.registerAdapter(HiveSaleItemAdapter());
    final saleBox = await Hive.openBox<HiveSaleInvoice>('saleInvoices');
    print(
        '📦 Hive box "saleInvoices" opened. Current items: ${saleBox.values.length}');

    // CacheHelper
    final cacheHelper = CacheHelper();
    await cacheHelper.init();
    role = cacheHelper.getData(key: 'Role');

    // NotificationService
    await NotificationService.instance.init();

    // Http Consumer + Remote Data Source
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);
    final remoteDataSource = SaleRemoteDataSource(api: httpConsumer);

    // Local Data Source
    final localDataSource = LocalSaleDataSourceImpl(saleBox: saleBox);

    // Network Info
    final networkInfo = NetworkInfoImpl();

    // Repository
    final saleRepository = SaleRepositoryImpl(
      localDataSource,
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    Get.put(saleRepository);

    // Nominatim
    await NominatimGeocoding.init(reqCacheNum: 20);

    // Controllers
    Get.put(ThemeController());
    Get.put(LocaleController());
    Get.put(NotificationController(), permanent: true);
  }

  /// Wrapper لتشغيل التطبيق مع Sizer
  static Widget runAppWithSizer(Widget app) {
    return Sizer(builder: (context, orientation, deviceType) => app);
  }
}
