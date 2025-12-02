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
import 'package:teriak/features/stock_management/data/models/hive_stock_model.dart';
import 'package:teriak/features/customer_managment/data/models/hive_customer_model.dart';
import 'package:teriak/features/products/all_products/data/models/hive_product_model.dart';
import 'package:teriak/features/products/add_product/data/models/hive_pending_product_model.dart';
import 'package:teriak/features/products/product_data/data/models/hive_product_data_model.dart';
import 'package:teriak/features/products/product_data/data/models/hive_product_names_model.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/hive_supplier_model.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/hive_purchase_order_model.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/data/models/hive_product_item_model.dart';
import 'package:teriak/features/purchase_order/add_purchase_order/data/models/hive_pending_purchase_order_model.dart';
import 'package:teriak/features/money_box/data/models/hive_money_box_model.dart';
import 'package:teriak/features/money_box/data/models/hive_money_box_transaction_model.dart';

String? role;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final saleBox = await _initHive();
  await _initCoreDependencies(saleBox);
  await _initExternalServices();
  _registerControllers();

  runApp(
    Sizer(
      builder: (context, orientation, deviceType) => const MyApp(),
    ),
  );
}

Future<Box<HiveSaleInvoice>> _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HiveSaleInvoiceAdapter());
  Hive.registerAdapter(HiveSaleItemAdapter());
  Hive.registerAdapter(HiveStockModelAdapter());
  Hive.registerAdapter(HiveCustomerModelAdapter());
  Hive.registerAdapter(HiveProductModelAdapter());
  Hive.registerAdapter(HivePendingProductModelAdapter());
  Hive.registerAdapter(HiveProductDataModelAdapter());
  Hive.registerAdapter(HiveProductNamesModelAdapter());
  Hive.registerAdapter(HiveSupplierModelAdapter());
  Hive.registerAdapter(HiveProductItemModelAdapter());
  Hive.registerAdapter(HivePurchaseOrderModelAdapter());
  Hive.registerAdapter(HivePendingPurchaseOrderModelAdapter());
  Hive.registerAdapter(HiveMoneyBoxModelAdapter());
  Hive.registerAdapter(HiveMoneyBoxTransactionModelAdapter());
  await Hive.openBox<HiveStockModel>('stockCache');
  await Hive.openBox<String>('stockDetailsCache');
  await Hive.openBox<HiveCustomerModel>('customerCache');
  await Hive.openBox<HiveProductModel>('productCache');
  await Hive.openBox<HivePendingProductModel>('pendingProducts');
  await Hive.openBox<HiveProductDataModel>('productDataCache');
  await Hive.openBox<HiveProductNamesModel>('productNamesCache');
  await Hive.openBox<HiveSupplierModel>('supplierCache');
  await Hive.openBox<HivePurchaseOrderModel>('purchaseOrderCache');
  await Hive.openBox<HivePendingPurchaseOrderModel>('pendingPurchaseOrders');
  await Hive.openBox<HiveMoneyBoxModel>('moneyBoxCache');
  await Hive.openBox<HiveMoneyBoxTransactionModel>('moneyBoxTransactionCache');
  return Hive.openBox<HiveSaleInvoice>('saleInvoices');
}

Future<void> _initCoreDependencies(Box<HiveSaleInvoice> saleBox) async {
  final cacheHelper = CacheHelper();
  await cacheHelper.init();
  role = cacheHelper.getData(key: 'Role');

  // Initialize Sale Repository
  final localSaleDataSource = LocalSaleDataSourceImpl(saleBox: saleBox);
  final httpConsumer =
      HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);
  final remoteSaleDataSource = SaleRemoteDataSource(api: httpConsumer);
  final networkInfo = NetworkInfoImpl();

  final saleRepository = SaleRepositoryImpl(
    localSaleDataSource,
    remoteDataSource: remoteSaleDataSource,
    networkInfo: networkInfo,
  );
  Get.put(saleRepository);
}

Future<void> _initExternalServices() async {
  await NominatimGeocoding.init(reqCacheNum: 20);
}

void _registerControllers() {
  Get.put(ThemeController());
  Get.put(LocaleController());
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
