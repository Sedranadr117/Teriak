import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/customer_managment/data/datasources/customer_remote_data_source.dart';
import 'package:teriak/features/customer_managment/data/models/customer_model.dart';
import 'package:teriak/features/customer_managment/data/repositories/customer_repository_impl.dart';
import 'package:teriak/features/customer_managment/domain/entities/customer_entity.dart';
import 'package:teriak/features/customer_managment/domain/usecases/create_customer.dart';
import 'package:teriak/features/customer_managment/domain/usecases/delete_employee.dart';
import 'package:teriak/features/customer_managment/domain/usecases/edit_employee.dart';
import 'package:teriak/features/customer_managment/domain/usecases/search_customer.dart';
import '../../domain/usecases/get_customers.dart';

class CustomerController extends GetxController {
  RxList<CustomerModel> customers = <CustomerModel>[].obs;
  Rx<CustomerModel?> selectedCustomer = Rx<CustomerModel?>(null);
  TextEditingController searchController = TextEditingController();
  final Rx<CustomerEntity?> customer = Rx<CustomerEntity?>(null);

  late final NetworkInfoImpl networkInfo;
  late final GetCustomers _getCustomers;
  late final SearchCustomer _searchCustomer;
  late final CreateCustomer _createCustomer;
  late final DeleteCustomer _deleteCustomer;
  late final EditCustomer _editCustomer;
  RxBool isSuccess = false.obs;
  var isLoading = false.obs;
  var isEditing = false;
  var errorMessage = ''.obs;
  int? lastSelectedCustomerId;

  RxList<CustomerModel> results = <CustomerModel>[].obs;

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final debtAmountController = TextEditingController();
  final notesController = TextEditingController();
  final Rx<RxStatus?> searchStatus = Rx<RxStatus?>(null);

  @override
  void onInit() {
    super.onInit();
    initializeDependencies();
    fetchCustomers();
  }

  void refresh() {
    fetchCustomers();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    debtAmountController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void initializeDependencies() {
    final cacheHelper = CacheHelper();
    networkInfo = NetworkInfoImpl(InternetConnection());
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    final remoteDataSource = CustomerRemoteDataSource(api: httpConsumer);

    final repository = CustomerRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    _getCustomers = GetCustomers(repository: repository);
    _createCustomer = CreateCustomer(repository: repository);
    _searchCustomer = SearchCustomer(repository: repository);
    _deleteCustomer = DeleteCustomer(repository);
    _editCustomer = EditCustomer(repository: repository);
  }

  void selectCustomer(CustomerEntity newEmployee) {
    lastSelectedCustomerId = newEmployee.id;
    customer.value = newEmployee;
  }

  Future<void> fetchCustomers() async {
    print('🚀  Starting fetch customers process...');
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
      final result = await _getCustomers();

      result.fold(
        (failure) {
          errorMessage.value = failure.errMessage;
          print('❌  Failed to fetch customers: ${failure.errMessage}');
          Get.snackbar(
              'Error'.tr, 'Faild to get customer please try again later'.tr);
        },
        (list) {
          customers.assignAll(
            list.map((entity) => CustomerModel(
                  id: entity.id,
                  name: entity.name,
                  phoneNumber: entity.phoneNumber,
                  address: entity.address,
                  notes: entity.notes,
                )),
          );

          print('✅  Successfully fetched ${list.length} customers.');
          final defaultCustomer = customers.firstWhereOrNull(
            (c) => c.name.toLowerCase() == 'cash customer',
          );
          if (defaultCustomer != null) {
            selectedCustomer.value = defaultCustomer;
          }
          for (var c in customers) {
            print('Customer: ID=${c.id}, Name=${c.name}');
          }
        },
      );
    } catch (e) {
      print('💥  Exception occurred while fetching customers: $e');
      errorMessage.value =
          'An unexpected error occurred while fetching customers.'.tr;
    } finally {
      isLoading.value = false;
      print('🔚  Fetch customers process finished.');
    }
  }

  Future<void> deleteCustomer(int id) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _deleteCustomer(id);
      result.fold(
        (failure) {
          errorMessage.value = failure.errMessage;
          Get.snackbar('Error'.tr, failure.errMessage);
        },
        (_) {
          Get.snackbar('Success'.tr, 'Customer deleted successfully!'.tr);
          fetchCustomers();
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

  Future<void> createCustomer() async {
    print('🚀  Starting create customers process...');
    if (!formKey.currentState!.validate()) return;

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

      print('📥  creating customer from API...');
      final cusromerData = CustomerParams(
          notes: notesController.text,
          name: nameController.text,
          phoneNumber: phoneController.text,
          address: addressController.text);

      final result = await _createCustomer(
          name: cusromerData.name,
          address: cusromerData.address,
          phoneNumber: cusromerData.phoneNumber,
          notes: cusromerData.notes);

      result.fold(
        (failure) {
          errorMessage.value = failure.errMessage;
          print('❌  Failed to fetch customers: ${failure.errMessage}');
          Get.snackbar(
              'Error'.tr, 'Faild to create customer please try again later'.tr);
        },
        (list) async {
          customer.value = list;
          Get.offNamed(AppPages.indebtedManagement);
          Get.snackbar('Success'.tr, 'Customer created successfully'.tr);

          print('✅  Successfully create customers.');
          nameController.clear();
          phoneController.clear();
          addressController.clear();
          notesController.clear();
        },
      );
    } catch (e) {
      print('💥  Exception occurred while fetching customers: $e');
      errorMessage.value =
          'An unexpected error occurred while fetching customers.';
    } finally {
      isLoading.value = false;
      print('🔚  create customers process finished.');
    }
  }

  Future<void> editCustomer(int customerId, CustomerParams params) async {
    isEditing = true;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _editCustomer(
          id: customerId,
          name: params.name,
          phoneNumber: params.phoneNumber,
          address: params.address,
          notes: params.name);
      result.fold(
        (failure) {
          errorMessage.value = failure.errMessage;
          Get.snackbar('Error'.tr, failure.errMessage);
        },
        (updatedEmployee) {
          Get.snackbar('Success'.tr, 'customer updated successfully!'.tr);
          Get.offNamed(AppPages.indebtedManagement);
        },
      );
    } catch (e) {
      print('❌ Error editing customer: $e');
      errorMessage.value = 'Failed to update customer.'.tr;
      Get.snackbar('Error'.tr, errorMessage.value);
    } finally {
      isLoading.value = false;
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

      final result = await _searchCustomer(params: q);
      result.fold(
        (failure) {
          results.clear();
          errorMessage.value = failure.errMessage;
          searchStatus.value = RxStatus.error(failure.errMessage);
          print('Search Error: ${failure.errMessage}');
        },
        (list) {
          results.clear();
          results.assignAll(list.map((entity) => CustomerModel(
                id: entity.id,
                name: entity.name,
                phoneNumber: entity.phoneNumber,
                address: entity.address,
                notes: entity.notes,
              )));
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
}
