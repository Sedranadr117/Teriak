// controllers/add_supplier_controller.dart
import 'package:get/get.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/purchase_order/delete_purchase_order/data/datasources/delete_supplier_remote_data_source.dart';
import 'package:teriak/features/purchase_order/delete_purchase_order/data/repositories/delete_supplier_repository_impl.dart';
import 'package:teriak/features/purchase_order/delete_purchase_order/domain/usecases/delete_supplier.dart';

class DeletePurchaseOrderController extends GetxController {
  late final NetworkInfoImpl networkInfo;
  late final DeletePurchaseOrder deletePurchaseOrderUseCase;
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

    final remoteDataSource =
        DeletePurchaseOrderRemoteDataSource(api: httpConsumer);

    final repository = DeletePurchaseOrderRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    deletePurchaseOrderUseCase = DeletePurchaseOrder(repository: repository);
  }

  Future<void> deletePurchaseOrder(int purchaseOrderId) async {
    isLoading.value = true;

    try {
      final params = DeletePurchaseOrderParams(
        id: purchaseOrderId,
      );

      final result = await deletePurchaseOrderUseCase(
        params: params,
      );

      result.fold(
        (failure) {
          Get.snackbar('Error', failure.errMessage);
          print(failure.errMessage.toString());
        },
        (x) {
          Get.snackbar('Success', 'PurchaseOrder deleted successfully');
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
