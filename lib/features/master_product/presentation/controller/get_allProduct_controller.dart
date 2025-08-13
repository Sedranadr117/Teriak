import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/master_product/data/datasources/product_remote_data_source.dart';
import 'package:teriak/features/master_product/data/repositories/product_repository_impl.dart';
import 'package:teriak/features/master_product/domain/usecases/get_product.dart';

class GetAllProductController extends GetxController {
  late final NetworkInfoImpl networkInfo;
  late final GetAllProduct getAllProductUseCase;
  var isLoading = true.obs;
  var products = [].obs;
  var errorMessage = ''.obs;
  var isRefreshing = false.obs;

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

    final remoteDataSource = ProductRemoteDataSource(api: httpConsumer);

    final repository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    getAllProductUseCase = GetAllProduct(repository: repository);
    getProducts();
  }

  void getProducts() async {
    try {
      isLoading.value = true;
      String currentLanguageCode = LocaleController.to.locale.languageCode;
      final q = AllProductParams(
        languageCode: currentLanguageCode,
      );
      final result = await getAllProductUseCase(params: q);
      result.fold(
        (failure) => errorMessage.value = failure.errMessage,
        (productList) {
          // Ensure we have unique products based on ID
          final uniqueProducts = productList.fold<List<dynamic>>(
            [],
            (list, product) {
              if (!list.any((p) => p.id == product.id)) {
                list.add(product);
              }
              return list;
            },
          );
          products.value = uniqueProducts;
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      print(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProducts() async {
    try {
      isRefreshing.value = true;
      await Future.delayed(const Duration(milliseconds: 1500));
      getProducts();
    } finally {
      isRefreshing.value = false;
    }
  }
}
