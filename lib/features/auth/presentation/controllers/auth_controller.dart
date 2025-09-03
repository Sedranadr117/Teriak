import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:teriak/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:teriak/features/auth/domain/usecases/get_auth.dart';
import 'package:teriak/features/auth/domain/entities/auth_entity.dart';
import 'package:teriak/main.dart';

class AuthController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<AuthEntity?> currentUser = Rx<AuthEntity?>(null);
  final RxBool isPharmacyLogin = false.obs;

  late final mangerLogin _mangerLogin;
  late final NetworkInfoImpl networkInfo;
  bool isPharmacyRegistrationComplete = false;

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

    final remoteDataSource = AuthRemoteDataSource(api: httpConsumer);

    final repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    _mangerLogin = mangerLogin(repository: repository);
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('📧 Email: ${emailController.text.trim()}');
      print('🔑 Password: ${passwordController.text.trim()}');

      print('🌐 Testing network connectivity...');
      final isConnected = await networkInfo.isConnected;
      print('📡 Network connected: $isConnected');

      if (!isConnected) {
        errorMessage.value =
            'No internet connection. Please check your network.'.tr;
        return;
      }

      final result = await _mangerLogin(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      print('✅ Login result received');

      result.fold(
        (failure) {
          print('❌ Login failed: ${failure.errMessage}');

          if (failure.statusCode == 400 || failure.statusCode == 401) {
            errorMessage.value = 'Email or password is incorrect'.tr;
          }
          if (failure.statusCode == 500) {
            errorMessage.value =
                'An unexpected error occurred. Please try again.'.tr;
          }
        },
        (authEntity) async {
          print('✅ Login successful!');
          print('🟢 isAuthenticated: ${authEntity.isAuthenticated}');
          print(
              '📧 Email: ${authEntity.email}, 🎫 Token: ${authEntity.token}, 👤 Name: ${authEntity.firstName} ${authEntity.lastName}, 🔐 Role: ${authEntity.role}');

          currentUser.value = authEntity;
          if (authEntity.isAuthenticated == true &&
              authEntity.token != null &&
              authEntity.token!.isNotEmpty) {
            final cacheHelper = CacheHelper();
            await cacheHelper.saveData(key: 'token', value: authEntity.token);
            await cacheHelper.saveData(key: 'Role', value: authEntity.role);
            if (authEntity.isActive == true) {
              Get.offNamed(AppPages.home);
            } else {
              role == "PHARMACY_MANAGER"
                  ? Get.offNamed(AppPages.pharmacyCompleteRegistration)
                  : Get.offNamed(AppPages.home);
            }
          } else {
            print('⛔️ Not authenticated, will not navigate!');
            errorMessage.value = 'Email or Password is wrong'.tr;
          }
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred. Please try again.'.tr;
      if (e.toString().contains('UnknownException')) {
        errorMessage.value = 'Email or Password is wrong'.tr;
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
