import 'package:get/get.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/features/settings/data/datasources/user_profile_remote_data_source.dart';
import 'package:teriak/features/settings/data/repositories/user_profile_repository_impl.dart';
import 'package:teriak/features/settings/domain/entities/user_profile_entity.dart';
import 'package:teriak/features/settings/domain/usecases/get_user_profile.dart';

class UserProfileController extends GetxController {
  final Rx<UserProfileEntity?> userProfile = Rx<UserProfileEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  late final NetworkInfoImpl networkInfo;
  late final GetUserProfile _getUserProfile;

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    fetchUserProfile();
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    networkInfo = NetworkInfoImpl();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    final remoteDataSource = UserProfileRemoteDataSource(api: httpConsumer);
    final repository = UserProfileRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    _getUserProfile = GetUserProfile(repository: repository);
  }

  Future<void> fetchUserProfile() async {
    print('🔄 Fetching user profile...');
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

      print('🚀 Making API call to fetch user profile...');
      final result = await _getUserProfile();

      result.fold(
        (failure) {
          print('❌ Error fetching user profile: ${failure.errMessage}');
          errorMessage.value = failure.errMessage;
          if (failure.statusCode == 404) {
            errorMessage.value = "No invoices found";
            Get.snackbar('Error'.tr, errorMessage.value);
          } else if (failure.statusCode == "500") {
            errorMessage.value =
                'An unexpected error occurred. Please try again.'.tr;
            Get.snackbar('Error'.tr, errorMessage.value);
          } else {
            errorMessage.value = failure.errMessage;
            Get.snackbar('Errors'.tr, errorMessage.value);
          }
        },
        (profile) {
          print('✅ User profile fetched successfully: ${profile.displayName}');
          print(
              '📋 Profile details: ID=${profile.id}, Email=${profile.email}, Role=${profile.roleName}');
          userProfile.value = profile;
        },
      );
    } catch (e) {
      print('💥 Unexpected error while fetching user profile: $e');
      print('🔍 Error type: ${e.runtimeType}');
      print('🔍 Error details: $e');
      errorMessage.value = 'An unexpected error occurred. Please try again.'.tr;
      Get.snackbar('Error'.tr, errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshUserProfile() async {
    await fetchUserProfile();
  }

  // Helper method to convert entity to map for widget
  Map<String, dynamic> getUserDataMap() {
    final profile = userProfile.value;
    if (profile == null) {
      return {
        "id": 0,
        "name": "Loading...".tr,
        "email": "loading@example.com",
        "role": "Loading...".tr,
        "pharmacyName": "Loading...".tr,
        "position": "Loading...".tr,
        "firstName": "Loading...".tr, // Added for UserProfileHeaderWidget
        "lastName": "".tr, // Added for UserProfileHeaderWidget
        "isAccountActive": false, // Default for loading state
      };
    }

    return {
      "id": profile.id,
      "firstName": profile.firstName,
      "lastName": profile.lastName,
      "name": profile.displayName, // For general display
      "email": profile.email,
      "role": profile.roleDescription,
      "pharmacyName": profile.pharmacyName,
      "position": profile.position ?? "No Position".tr,
      "isAccountActive": profile.isAccountActive,
    };
  }
}
