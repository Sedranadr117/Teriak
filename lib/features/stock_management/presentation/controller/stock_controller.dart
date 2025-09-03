import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/stock_management/data/datasources/Stock_remote_data_source.dart';
import 'package:teriak/features/stock_management/data/models/Stock_model.dart';
import 'package:teriak/features/stock_management/data/repositories/stock_repository_impl.dart';
import 'package:teriak/features/stock_management/domain/entities/stock_entity.dart';
import 'package:teriak/features/stock_management/domain/entities/stock_item_entity.dart';
import 'package:teriak/features/stock_management/domain/usecases/delete_stock.dart';
import 'package:teriak/features/stock_management/domain/usecases/edit_Stock.dart';
import 'package:teriak/features/stock_management/domain/usecases/get_stock.dart';
import 'package:teriak/features/stock_management/domain/usecases/get_stock_details.dart';
import 'package:teriak/features/stock_management/domain/usecases/search_stock.dart';

class StockController extends GetxController {
  var isLoading = false.obs;
  var isEditing = false;
  var errorMessage = ''.obs;
  int? lastSelectedCustomerId;
  final Rx<RxStatus?> searchStatus = Rx<RxStatus?>(null);
  TextEditingController searchController = TextEditingController();
  final RxList<StockEntity> allStokes = <StockEntity>[].obs;
  RxList<StockEntity> allStockOriginal = <StockEntity>[].obs;

  RxList<StockModel> results = <StockModel>[].obs;
  late final NetworkInfoImpl networkInfo;
  late final GetStock _getStock;
  late final SearchStock _searchStock;
  late final EditStock _editStock;
  late final DeleteStock _deleteStock;
  late final GetDetailsStock _getDetailsStock;
  late TabController tabController;
  RxList<StockDetailsEntity> stockDetails = <StockDetailsEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    initializeDependencies();
    fetchStock();
  }

  void initializeDependencies() {
    final cacheHelper = CacheHelper();
    networkInfo = NetworkInfoImpl();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    final remoteDataSource = StockRemoteDataSource(api: httpConsumer);

    final repository = StockRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    _getStock = GetStock(repository: repository);
    _searchStock = SearchStock(repository: repository);
    _editStock = EditStock(repository: repository);
    _deleteStock = DeleteStock(repository);
    _getDetailsStock = GetDetailsStock(repository);
  }

  Future<void> refreshStock() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    fetchStock();
    isLoading.value = false;
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
          print('❌  Failed to fetch Stock: ${failure.errMessage}');
          errorMessage.value = failure.errMessage;
          if (failure.statusCode == 500) {
            errorMessage.value =
                'An unexpected error occurred. Please try again.'.tr;
          }

          Get.snackbar(
              'Error'.tr, 'Faild to get stock please try again later'.tr);
        },
        (list) {
          allStokes.assignAll(list.map((e) => (e as StockModel).toEntity()));
          for (var emp in allStokes) {
            print('MYMID: ${emp.productName} ');
          }
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

  Future<void> fetchStockDetails({
    required int productId,
    required String productType,
  }) async {
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

      final result = await _getDetailsStock(
        productId: productId,
        productType: productType,
      );

      result.fold((failure) => errorMessage.value = failure.errMessage,
          (data) => {stockDetails.add(data)});
    } catch (e) {
      print('💥  Exception occurred while fetching Stock: $e');
      errorMessage.value =
          'An unexpected error occurred while fetching Stock.'.tr;
    } finally {
      isLoading.value = false;
      print('🔚  Fetch Stock process finished.');
    }
    isLoading.value = false;
  }

  Future<void> editStock(int stockId, StockParams params) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _editStock(
          id: stockId,
          quantity: params.quantity,
          expiryDate: params.expiryDate,
          minStockLevel: params.minStockLevel,
          reasonCode: params.reasonCode,
          additionalNotes: params.additionalNotes);
      result.fold(
        (failure) {
          errorMessage.value = failure.errMessage;

          if (failure.statusCode == 500) {
            errorMessage.value =
                'An unexpected error occurred. Please try again.'.tr;
          }
          if (failure.statusCode == 409) {
            errorMessage.value = 'Expiry date cannot be in the past'.tr;
          }
          Get.snackbar('Error'.tr, errorMessage.value);
        },
        (updatedEmployee) {
          Get.back();
          Get.offNamed(AppPages.stockManagement);
          Get.snackbar('Success'.tr, 'Stocks updated successfully!'.tr);
          fetchStock();
        },
      );
    } catch (e) {
      print('❌ Error editing Stock: $e');
      errorMessage.value = 'Failed to update Stock.'.tr;
      Get.snackbar('Error'.tr, errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> applyFilters(int tabIndex) {
    return allStokes
        .where((p) {
          switch (tabIndex) {
            case 0: // All Stock
              return true;
            case 1: // Low Stock
              final currentStock = (p.totalQuantity as num?)?.toInt() ?? 0;
              final minPoint = p.minStockLevel;
              if (minPoint == null) return false;
              return currentStock <= minPoint;
            case 2: // Near Expiry
              DateTime? expiry;
              if (p.earliestExpiryDate is String) {
                expiry = DateTime.tryParse(p.earliestExpiryDate as String);
              } else {
                expiry = p.earliestExpiryDate;
              }

              if (expiry == null) return false;

              final daysUntilExpiry = expiry.difference(DateTime.now()).inDays;
              for (final v in allStokes) {
                print(v.productName);
              }

              return daysUntilExpiry <= 30 && daysUntilExpiry >= 0;

            default:
              return true;
          }
        })
        .map((product) => {
              'id': product.id,
              'productId': product.productId,
              'productName': product.productName,
              'productType': product.productType,
              'barcodes': product.barcodes,
              'totalQuantity': product.totalQuantity,
              'totalBonusQuantity': product.totalBonusQuantity,
              'averagePurchasePrice': product.averagePurchasePrice,
              'totalValue': product.totalValue,
              'categories': product.categories,
              'sellingPrice': product.sellingPrice,
              'minStockLevel': product.minStockLevel,
              'hasExpiredItems': product.hasExpiredItems,
              'hasExpiringSoonItems': product.hasExpiringSoonItems,
              'earliestExpiryDate': product.earliestExpiryDate,
              'latestExpiryDate': product.latestExpiryDate,
              'numberOfBatches': product.numberOfBatches,
              'pharmacyId': product.pharmacyId,
            })
        .toList();
  }

  Future<void> search(String query) async {
    try {
      isLoading.value = true;
      print('Search Status: Loading');
      errorMessage.value = '';
      final q = SearchStockParams(
        keyword: query.trim(),
      );
      print('Searching for: $query');

      final result = await _searchStock(params: q);
      result.fold(
        (failure) {
          results.clear();
          searchStatus.value = RxStatus.error(failure.errMessage);
          errorMessage.value = failure.errMessage;
          if (failure.statusCode == 500) {
            errorMessage.value =
                'An unexpected error occurred. Please try again.'.tr;
          }
          print('Search Error: ${failure.errMessage}');
        },
        (list) {
          results.clear();
          results.assignAll(list.map((e) => StockModel.fromEntity(e)).toList());

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

  Future<void> deleteStock(int id) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _deleteStock(id);
      result.fold(
        (failure) {
          errorMessage.value = failure.errMessage;
          if (failure.statusCode == 500) {
            errorMessage.value =
                'Cannot delete this item because it is linked to a sale.'.tr;
          }
          Get.snackbar('Error'.tr, errorMessage.value);
        },
        (_) {
          Get.snackbar('Success'.tr, 'Stock deleted successfully!'.tr);

          fetchStock();
        },
      );
    } catch (e) {
      print('❌ Error deleting Customer: $e');
      errorMessage.value = 'Failed to delete Customer.'.tr;
      Get.snackbar('Error'.tr, errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
  //

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
