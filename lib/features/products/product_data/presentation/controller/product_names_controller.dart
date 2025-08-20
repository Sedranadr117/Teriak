import 'package:get/get.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/features/products/product_data/data/datasources/product_data_remote_data_source.dart';
import 'package:teriak/features/products/product_data/data/repositories/product_data_repository_impl.dart';
import 'package:teriak/features/products/product_data/domain/entities/product_names_entity.dart';
import 'package:teriak/features/products/product_data/domain/usecases/get_product_data.dart';

class ProductNamesController extends GetxController {
  late final NetworkInfoImpl networkInfo;
  late final GetProductData getProductDataUseCase;
  var isLoading = false.obs;
  var productNames = Rxn<ProductNamesEntity>();
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

    networkInfo = NetworkInfoImpl(InternetConnection());

    final remoteDataSource = ProductDataRemoteDataSource(api: httpConsumer);

    final repository = ProductDataRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    getProductDataUseCase = GetProductData(repository: repository);
  }

  Future<void> getProductNames(String type, int id) async {
    print(">>> getProductNames called with type=$type, id=$id");
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final params = ProductNamesParams(
        id: id,
        type: type,
      );

      print(">>> Calling API with params: ${params.toMap()}");

      final result = await getProductDataUseCase.callNames(params: params);
      result.fold(
        (failure) {
          errorMessage.value = failure.errMessage;
          print(">>> API Error: ${failure.errMessage}");
          productNames.value = null;
        },
        (data) {
          productNames.value = data;
          print(">>> API Success: ${data.tradeNameAr}, ${data.tradeNameEn}");
          print(">>> Full data: $data");
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      print(">>> Exception: $e");
      productNames.value = null;
    } finally {
      isLoading.value = false;
      print(
          ">>> getProductNames completed. Loading: ${isLoading.value}, Error: ${errorMessage.value}");
    }
  }
}
