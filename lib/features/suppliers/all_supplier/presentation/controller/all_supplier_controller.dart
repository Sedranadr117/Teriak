import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/features/suppliers/all_supplier/data/datasources/all_supplier_remote_data_source.dart';
import 'package:teriak/features/suppliers/all_supplier/data/models/supplier_model.dart';
import 'package:teriak/features/suppliers/all_supplier/data/repositories/all_supplier_repository_impl.dart';
import 'package:teriak/features/suppliers/all_supplier/domain/usecases/get_all_supplier.dart';

class GetAllSupplierController extends GetxController {
  late final NetworkInfoImpl networkInfo;
  late final GetAllSupplier getAllSupplierUseCase;

  // State variables
  var isLoading = true.obs;
  var isRefreshing = false.obs;
  var suppliers = <Map<String, dynamic>>[].obs;
  var filteredSuppliers = <Map<String, dynamic>>[].obs;
  var errorMessage = ''.obs;
  var searchQuery = ''.obs;
  var isDarkMode = false.obs;

  // Mock data for testing (remove in production)
  final List<Map<String, dynamic>> _mockSuppliers = [
    {
      "id": 1,
      "name": "Ahmed Electronics Co.",
      "phone": "+963 11 123 4567",
      "address": "Damascus, Syria",
      "preferredCurrency": "USD",
      "totalPayments": 15750.50,
      "totalDebts": 2300.00,
      "lastUpdated": DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      "id": 2,
      "name": "Global Tech Solutions",
      "phone": "+1 555 987 6543",
      "address": "New York, USA",
      "preferredCurrency": "USD",
      "totalPayments": 42500.75,
      "totalDebts": 8750.25,
      "lastUpdated": DateTime.now().subtract(const Duration(hours: 6)),
    },
    {
      "id": 3,
      "name": "Mediterranean Supplies",
      "phone": "+963 21 456 7890",
      "address": "Aleppo, Syria",
      "preferredCurrency": "EUR",
      "totalPayments": 28900.00,
      "totalDebts": 1200.50,
      "lastUpdated": DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      "id": 4,
      "name": "Digital Innovation Hub",
      "phone": "+44 20 7946 0958",
      "address": "London, UK",
      "preferredCurrency": "GBP",
      "totalPayments": 67200.30,
      "totalDebts": 12400.75,
      "lastUpdated": DateTime.now().subtract(const Duration(hours: 12)),
    },
    {
      "id": 5,
      "name": "Levant Trading Company",
      "phone": "+963 31 789 0123",
      "address": "Homs, Syria",
      "preferredCurrency": "USD",
      "totalPayments": 19850.25,
      "totalDebts": 3600.00,
      "lastUpdated": DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      "id": 6,
      "name": "European Components Ltd",
      "phone": "+49 30 12345678",
      "address": "Berlin, Germany",
      "preferredCurrency": "EUR",
      "totalPayments": 89500.80,
      "totalDebts": 15200.40,
      "lastUpdated": DateTime.now().subtract(const Duration(hours: 18)),
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    _loadMockData(); // Remove this in production
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl1, cacheHelper: cacheHelper);

    networkInfo = NetworkInfoImpl(InternetConnection());

    final remoteDataSource = AllSupplierRemoteDataSource(api: httpConsumer);

    final repository = AllSupplierRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    getAllSupplierUseCase = GetAllSupplier(repository: repository);
  }

  // Load mock data for testing (remove in production)
  void _loadMockData() {
    suppliers.value = List.from(_mockSuppliers);
    filteredSuppliers.value = List.from(_mockSuppliers);
    isLoading.value = false;
  }

  // Get suppliers from API
  void getSuppliers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await getAllSupplierUseCase();
      result.fold(
        (failure) {
          errorMessage.value = failure.errMessage;
          // Fallback to mock data for now
          _loadMockData();
        },
        (supplierList) {
          // Convert SupplierModel list to Map list
          final suppliersMap =
              supplierList.map((supplier) => supplier.toJson()).toList();
          suppliers.value = suppliersMap;
          filteredSuppliers.value = List.from(suppliersMap);
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      // Fallback to mock data for now
      _loadMockData();
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh suppliers
  Future<void> refreshSuppliers() async {
    try {
      isRefreshing.value = true;
      await Future.delayed(
          const Duration(milliseconds: 1500)); // Simulate API delay
      getSuppliers();
    } finally {
      isRefreshing.value = false;
    }
  }

  // Search and filter suppliers
  void searchSuppliers(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      filteredSuppliers.value = List.from(suppliers);
    } else {
      filteredSuppliers.value = suppliers.where((supplier) {
        final name = (supplier["name"] as String? ?? "").toLowerCase();
        final phone = (supplier["phone"] as String? ?? "").toLowerCase();
        final address = (supplier["address"] as String? ?? "").toLowerCase();
        final searchQuery = query.toLowerCase();

        return name.contains(searchQuery) ||
            phone.contains(searchQuery) ||
            address.contains(searchQuery);
      }).toList();
    }
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
    filteredSuppliers.value = List.from(suppliers);
  }

  // Toggle theme
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }

  // Delete supplier
  void deleteSupplier(Map<String, dynamic> supplier) {
    suppliers.removeWhere((s) => s["id"] == supplier["id"]);
    searchSuppliers(searchQuery.value);
  }

  // Add supplier back (for undo functionality)
  void addSupplierBack(Map<String, dynamic> supplier) {
    suppliers.add(supplier);
    searchSuppliers(searchQuery.value);
  }

  // Get supplier by ID
  Map<String, dynamic>? getSupplierById(int id) {
    try {
      return suppliers.firstWhere((supplier) => supplier["id"] == id);
    } catch (e) {
      return null;
    }
  }

  // Get suppliers count
  int get suppliersCount => suppliers.length;

  // Get filtered suppliers count
  int get filteredSuppliersCount => filteredSuppliers.length;

  // Check if search has results
  bool get hasSearchResults => filteredSuppliers.isNotEmpty;

  // Check if search is active
  bool get isSearchActive => searchQuery.value.isNotEmpty;
}
