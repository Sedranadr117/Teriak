// controllers/add_Product_controller.dart
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/products/delete_product/data/datasources/delete_product_remote_data_source.dart';
import 'package:teriak/features/products/delete_product/data/repositories/delete_product_repository_impl.dart';
import 'package:teriak/features/products/delete_product/domain/usecases/delete_product.dart';

class DeleteProductController extends GetxController {
  late final NetworkInfoImpl networkInfo;
  late final DeleteProduct deleteProductUseCase;
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

    networkInfo = NetworkInfoImpl(InternetConnection());

    final remoteDataSource = DeleteProductRemoteDataSource(api: httpConsumer);

    final repository = DeleteProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    deleteProductUseCase = DeleteProduct(repository: repository);
  }

  Future<void> deleteProduct(int ProductId) async {
    isLoading.value = true;

    try {
      final params = DeleteProductParams(
        id: ProductId,
      );

      final result = await deleteProductUseCase(
        params: params,
      );

      result.fold(
        (failure) {
          if (failure.statusCode == 409) {
            Get.snackbar(
                'Error',
                'Cannot delete pharmacy product. It has stock items. Please remove all stock items first'.tr
                    .tr);
          } else {
            Get.snackbar('Error', failure.errMessage);
          }
        },
        (x) {
          Get.snackbar('Success', 'Product deleted successfully');
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());

    } finally {
      isLoading.value = false;
    }
  }
}
