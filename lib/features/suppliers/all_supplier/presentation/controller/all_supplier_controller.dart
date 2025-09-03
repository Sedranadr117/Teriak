import 'package:get/get.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/features/suppliers/all_supplier/data/datasources/all_supplier_remote_data_source.dart';
import 'package:teriak/features/suppliers/all_supplier/data/repositories/all_supplier_repository_impl.dart';
import 'package:teriak/features/suppliers/all_supplier/domain/usecases/get_all_supplier.dart';

class GetAllSupplierController extends GetxController {
  late final NetworkInfoImpl networkInfo;
  late final GetAllSupplier getAllSupplierUseCase;

  var isLoading = true.obs;
  var isRefreshing = false.obs;
  var suppliers = [].obs;
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

    final repository = AllSupplierRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    getAllSupplierUseCase = GetAllSupplier(repository: repository);
    getSuppliers();
  }

  void getSuppliers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await getAllSupplierUseCase();
      result.fold(
        (failure) {
          errorMessage.value = failure.errMessage;
        },
        (supplierList) {
          // Ensure we have unique suppliers based on ID
          final uniqueSuppliers = supplierList.fold<List<dynamic>>(
            [],
            (list, supplier) {
              if (!list.any((s) => s.id == supplier.id)) {
                list.add(supplier);
              }
              return list;
            },
          );
          suppliers.value = uniqueSuppliers;
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshSuppliers() async {
    try {
      isRefreshing.value = true;
      await Future.delayed(const Duration(milliseconds: 1500));
      getSuppliers();
    } finally {
      isRefreshing.value = false;
    }
  }
}
