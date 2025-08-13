import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/config/widgets/custom_tab_bar.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/stock_management/data/datasources/Stock_remote_data_source.dart';
import 'package:teriak/features/stock_management/data/models/Stock_model.dart';
import 'package:teriak/features/stock_management/data/repositories/stock_repository_impl.dart';
import 'package:teriak/features/stock_management/domain/entities/stock_entity.dart';
import 'package:teriak/features/stock_management/domain/usecases/get_stock.dart';
import 'package:teriak/features/stock_management/domain/usecases/search_stock.dart';

class StockController extends GetxController {
  var isLoading = false.obs;
  var isEditing = false;
  var errorMessage = ''.obs;
  int? lastSelectedCustomerId;
  final Rx<RxStatus?> searchStatus = Rx<RxStatus?>(null);
  TextEditingController searchController = TextEditingController();
  final RxList<StockEntity> stock = <StockEntity>[].obs;
  final RxList<StockEntity> allStokes = <StockEntity>[].obs;

  RxList<StockModel> results = <StockModel>[].obs;
  late final NetworkInfoImpl networkInfo;
  late final GetStock _getStock;
  late final SearchStock _searchStock;

  final List<TabItem> tabs = [
    TabItem(label: 'All Stock'.tr, icon: Icons.inventory_2_outlined),
    TabItem(label: 'Low Stock'.tr, icon: Icons.warning_amber_outlined),
    TabItem(label: 'Near Expiry'.tr, icon: Icons.schedule_outlined),
  ];

  @override
  void onInit() {
    super.onInit();
    initializeDependencies();
  }

  void initializeDependencies() {
    final cacheHelper = CacheHelper();
    networkInfo = NetworkInfoImpl(InternetConnection());
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    final remoteDataSource = StockRemoteDataSource(api: httpConsumer);

    final repository = StockRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    _getStock = GetStock(repository: repository);
    _searchStock = SearchStock(repository: repository);
  }

  Future<void> refreshStock() async {
    await fetchStock();
  }

  Future<void> fetchStock() async {
    print('🚀  Starting fetch Stock process...');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('🌐  Checking internet connectivity...');
      final isConnected = await networkInfo.isConnected;
      print('📡  Network connected: $isConnected');

      if (!isConnected) {
        errorMessage.value =
            '⚠️ No internet connection. Please check your network.'.tr;
        Get.snackbar('Error'.tr,
            'No internet connection. Please check your network.'.tr);
        print('❌ No internet connection detected!');
        return;
      }

      print('📥  Fetching customer list from API...');
      final result = await _getStock();

      result.fold(
        (failure) {
          errorMessage.value = failure.errMessage;
          print('❌  Failed to fetch Stock: ${failure.errMessage}');
          Get.snackbar(
              'Error'.tr, 'Faild to get customer please try again later'.tr);
        },
        (list) {
          allStokes.assignAll(list.map((entity) => StockEntity()));
        },
      );
    } catch (e) {
      print('💥  Exception occurred while fetching Stock: $e');
      errorMessage.value =
          'An unexpected error occurred while fetching Stock.'.tr;
    } finally {
      isLoading.value = false;
      print('🔚  Fetch Stock process finished.');
    }
  }

  Future<void> search(String query) async {
    try {
      isLoading.value = true;
      print('Search Status: Loading');
      errorMessage.value = '';
      final q = SearchParams(
        name: query.trim(),
      );
      print('Searching for: $query');

      final result = await _searchStock(params: q);
      result.fold(
        (failure) {
          results.clear();
          errorMessage.value = failure.errMessage;
          searchStatus.value = RxStatus.error(failure.errMessage);
          print('Search Error: ${failure.errMessage}');
        },
        (list) {
          results.clear();
          results.assignAll(list.map((entity) => StockModel()).toList());

          print('Search Results: ${results.length} items');
          if (list.isEmpty) {
            results.clear();
            searchStatus.value = RxStatus.empty();
            print('Search Status: Empty Results');
          } else {
            searchStatus.value = RxStatus.success();
          }
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      searchStatus.value = RxStatus.error(e.toString());
      print('Search Status: Error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
