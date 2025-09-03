import 'package:get/get.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/purchase_order/all_purchase_orders/domain/entities/purchase_entity .dart';
import 'package:teriak/features/purchase_order/purchase_order_deatails/data/datasources/details_purchase_remote_data_source.dart';
import 'package:teriak/features/purchase_order/purchase_order_deatails/data/repositories/details_purchase_repository_impl.dart';
import 'package:teriak/features/purchase_order/purchase_order_deatails/domain/usecases/get_details_purchase.dart';
import 'package:teriak/features/suppliers/search_supplier/data/datasources/search_supplier_remote_data_source.dart';

class PurchaseOrderDetailsController extends GetxController {
  late final NetworkInfoImpl networkInfo;
  late final GetDetailsPurchaseOrders getDetailsPurchaseOrdersUseCase;

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var purchaseOrder = Rxn<PurchaseOrderEntity>();
  var supplierId = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();

    final args = Get.arguments as Map?;
    if (args != null && args['id'] != null) {
      final int id = args['id'];
      getPurchaseOrderDetails(id: id);
    }
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    networkInfo = NetworkInfoImpl();

    final remoteDataSource =
        DetailsPurchaseOrdersRemoteDataSource(api: httpConsumer);

    final repository = DetailsPurchaseOrdersRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    getDetailsPurchaseOrdersUseCase =
        GetDetailsPurchaseOrders(repository: repository);
  }

  Future<void> getPurchaseOrderDetails({
    required int id,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    purchaseOrder.value = null;
    supplierId.value = null;

    String currentLanguageCode = LocaleController.to.locale.languageCode;
    final params =
        DetailsPurchaseOrdersParams(id: id, languageCode: currentLanguageCode);

    try {
      final result = await getDetailsPurchaseOrdersUseCase(params: params);

      result.fold(
        (failure) => errorMessage.value = failure.errMessage,
        (data) {
          purchaseOrder.value = data;
          // Search for supplier ID after getting order details
          if (data.supplierName.isNotEmpty) {
            _searchSupplierId(data.supplierName);
          }
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshPurchaseOrderDetails() async {
    final args = Get.arguments as Map?;
    if (args != null && args['id'] != null) {
      final int id = args['id'];
      await getPurchaseOrderDetails(id: id);
    }
  }

  Future<void> _searchSupplierId(String supplierName) async {
    try {
      final cacheHelper = CacheHelper();
      final httpConsumer =
          HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

      final searchDataSource =
          SearchSupplierRemoteDataSource(api: httpConsumer);
      final params = SearchSupplierParams(keyword: supplierName);

      final suppliers = await searchDataSource.searchSupplier(params);

      if (suppliers.isNotEmpty) {
        // Find exact match or first match
        final exactMatch = suppliers.firstWhereOrNull((supplier) =>
            supplier.name.toLowerCase() == supplierName.toLowerCase());

        if (exactMatch != null) {
          supplierId.value = exactMatch.id;
        } else if (suppliers.isNotEmpty) {
          // Use first match if no exact match found
          supplierId.value = suppliers.first.id;
        }
      }
    } catch (e) {
      // If search fails, we'll continue without supplier ID
      print('Failed to search for supplier ID: $e');
    }
  }
}
