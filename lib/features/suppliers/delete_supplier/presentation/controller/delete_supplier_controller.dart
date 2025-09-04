// controllers/add_supplier_controller.dart
import 'package:get/get.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/suppliers/delete_supplier/data/datasources/delete_supplier_remote_data_source.dart';
import 'package:teriak/features/suppliers/delete_supplier/data/repositories/delete_supplier_repository_impl.dart';
import 'package:teriak/features/suppliers/delete_supplier/domain/usecases/delete_supplier.dart';

class DeleteSupplierController extends GetxController {
  late final NetworkInfoImpl networkInfo;
  late final DeleteSupplier deleteSupplierUseCase;
  var isLoading = false.obs;

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

    final remoteDataSource = DeleteSupplierRemoteDataSource(api: httpConsumer);

    final repository = DeleteSupplierRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    deleteSupplierUseCase = DeleteSupplier(repository: repository);
  }

  Future<void> deleteSupplier(int supplierId) async {
    isLoading.value = true;

    try {
      final params = SupplierParams(
        id: supplierId,
      );

      final result = await deleteSupplierUseCase(
        params: params,
      );

      result.fold(
        (failure) {
          if (failure.statusCode == 409) {
            Get.snackbar(
                'Error',
                'You cannot delete the supplier because he has purchase invoices'
                    .tr);
          } else {
            Get.snackbar('Error', failure.errMessage);
          }
        },
        (x) {
          Get.snackbar('Success', 'Supplier deleted successfully');
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
