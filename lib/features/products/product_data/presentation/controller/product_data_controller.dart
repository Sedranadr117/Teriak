import 'package:get/get.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/features/products/product_data/data/datasources/product_data_remote_data_source.dart';
import 'package:teriak/features/products/product_data/data/repositories/product_data_repository_impl.dart';
import 'package:teriak/features/products/product_data/domain/usecases/get_product_data.dart';

class ProductDataController extends GetxController {
  late final NetworkInfoImpl networkInfo;
  late final GetProductData getProductDataUseCase;
  var isLoading = false.obs;
  var dataList = [].obs;
  var errorMessage = ''.obs;

  late final GetProductData remoteDataSource;

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

    final remoteDataSource = ProductDataRemoteDataSource(api: httpConsumer);

    final repository = ProductDataRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    getProductDataUseCase = GetProductData(repository: repository);
  }

  Future<void> getProductData(String type) async {
    try {
      isLoading.value = true;
      String currentLanguageCode = LocaleController.to.locale.languageCode;

      final params = ProductDataParams(
        languageCode: currentLanguageCode,
        type: type,
      );

      final result = await getProductDataUseCase.callData(params: params);
      result.fold(
        (failure) => errorMessage.value = failure.errMessage,
        (productList) => dataList.value = productList,
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
