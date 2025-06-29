import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:teriak/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:teriak/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:teriak/features/auth/domain/usecases/get_auth.dart';
import 'package:teriak/features/auth/domain/entities/auth_entitiy.dart';

class AuthController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<AuthEntity?> currentUser = Rx<AuthEntity?>(null);

  late final AdminLogin _adminLogin;
  late final Logout _logout;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    _checkCachedAuth();
  }

  void _initializeDependencies() {
    // Initialize dependencies (in a real app, this would be done via dependency injection)
    final httpConsumer = HttpConsumer(baseUrl: EndPoints.baserUrl);
    final cacheHelper = CacheHelper();
    final networkInfo = NetworkInfoImpl(InternetConnection());

    final remoteDataSource = AuthRemoteDataSource(api: httpConsumer);
    final localDataSource = AuthLocalDataSource(cache: cacheHelper);
    final repository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );

    _adminLogin = AdminLogin(repository: repository);
    _logout = Logout(repository: repository);
  }

  void _checkCachedAuth() {
    // Check if user is already logged in from cache
    // This would typically check for a stored token
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _adminLogin(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      result.fold(
        (failure) {
          errorMessage.value = failure.errMessage;
        },
        (authEntity) {
          currentUser.value = authEntity;
          if (authEntity.isAuthenticated) {
            Get.offNamed(AppPages.employeeManagement);
          }
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;

    try {
      final result = await _logout();
      result.fold(
        (failure) {
          errorMessage.value = failure.errMessage;
        },
        (authEntity) {
          currentUser.value = null;
          Get.offAllNamed(AppPages.signin);
        },
      );
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred during logout.';
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
