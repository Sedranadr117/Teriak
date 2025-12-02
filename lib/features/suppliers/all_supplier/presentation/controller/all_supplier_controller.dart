import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/features/suppliers/all_supplier/data/datasources/all_supplier_remote_data_source.dart';
import 'package:teriak/features/suppliers/all_supplier/data/datasources/supplier_local_data_source.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/hive_supplier_model.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import 'package:teriak/features/suppliers/all_supplier/data/repositories/all_supplier_repository_impl.dart';
import 'package:teriak/features/suppliers/all_supplier/domain/usecases/get_all_supplier.dart';

class GetAllSupplierController extends GetxController {
  late final NetworkInfoImpl networkInfo;
  late final GetAllSupplier getAllSupplierUseCase;
  late final SupplierLocalDataSource localDataSource;

  var isLoading = true.obs;
  var isRefreshing = false.obs;
  var suppliers = <SupplierModel>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    networkInfo = NetworkInfoImpl();

    final remoteDataSource = AllSupplierRemoteDataSource(api: httpConsumer);
    final supplierBox = Hive.box<HiveSupplierModel>('supplierCache');
    localDataSource = SupplierLocalDataSourceImpl(supplierBox: supplierBox);

    final repository = AllSupplierRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
      localDataSource: localDataSource,
    );

    getAllSupplierUseCase = GetAllSupplier(repository: repository);
    getSuppliers();
  }

  void getSuppliers({bool refresh = false, bool skipCache = false}) async {
    try {
      if (refresh) {
        isLoading.value = true;
        suppliers.clear();
      } else {
        isLoading.value = true;
      }
      errorMessage.value = '';

      final result = await getAllSupplierUseCase(skipCache: skipCache);
      result.fold(
        (failure) {
          if (failure.statusCode == 401) {
            Get.snackbar('Error'.tr, "login cancel".tr);
          } else {
            errorMessage.value = failure.errMessage;
          }
        },
        (supplierList) {
          print('📦 Received ${supplierList.length} suppliers from repository');
          // Ensure we have unique suppliers based on ID
          final uniqueSuppliers = <SupplierModel>[];
          final seenIds = <int>{};

          for (final supplier in supplierList) {
            if (!seenIds.contains(supplier.id)) {
              uniqueSuppliers.add(supplier);
              seenIds.add(supplier.id);
            }
          }

          print(
              '✅ Setting ${uniqueSuppliers.length} unique suppliers to observable list');
          suppliers.value = uniqueSuppliers;
          print('📊 Suppliers list now has ${suppliers.length} items');
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred. Please try again.'.tr;
      Get.snackbar(
        'Error'.tr,
        errorMessage.value,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshSuppliers({bool skipCache = true}) async {
    try {
      isRefreshing.value = true;
      await Future.delayed(const Duration(milliseconds: 1000));

      // Check if we're online
      final isConnected = await networkInfo.isConnected;

      // If offline, always use cached data (don't skip cache)
      final shouldSkipCache = isConnected ? skipCache : false;

      getSuppliers(refresh: true, skipCache: shouldSkipCache);
    } finally {
      isRefreshing.value = false;
    }
  }
}
