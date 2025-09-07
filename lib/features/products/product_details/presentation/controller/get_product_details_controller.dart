import 'package:get/get.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/features/products/all_products/domain/entities/product_entity.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/products/product_details/data/datasources/product_details_remote_data_source.dart';
import 'package:teriak/features/products/product_details/data/repositories/product_details_repository_impl.dart';
import 'package:teriak/features/products/product_details/domain/usecases/get_product_details.dart';

class GetProductDetailsController extends GetxController {
  late final NetworkInfoImpl networkInfo;
  late final GetProductDetails getProductDetailsUseCase;

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var product = Rxn<ProductEntity>();

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();

    final args = Get.arguments as Map;
    final int id = args['id'];
    final String type = args['type'];

    getProductDetails(id: id, type: type);
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    networkInfo = NetworkInfoImpl();

    final remoteDataSource = ProductDetailsRemoteDataSource(api: httpConsumer);

    final repository = ProductDetailsRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    getProductDetailsUseCase = GetProductDetails(repository: repository);
  }

  Future<void> getProductDetails({
    required int id,
    required String type,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    product.value = null;
    String currentLanguageCode = LocaleController.to.locale.languageCode;
    final params = ProductDetailsParams(
        id: id, languageCode: currentLanguageCode, type: type);

    try {
      final result = await getProductDetailsUseCase(params: params);

      result.fold(
        (failure) {
          if (failure.statusCode == 401) {
            Get.snackbar('Error'.tr, "login cancel".tr);
          } else {
            errorMessage.value = failure.errMessage;
          }
        },
        (data) => product.value = data,
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
}
