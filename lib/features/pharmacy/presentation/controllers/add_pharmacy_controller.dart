import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/core/connection/network_info.dart';
import 'package:teriak/core/databases/api/end_points.dart';
import 'package:teriak/core/databases/api/http_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/pharmacy/data/datasources/pharmacy_remote_data_source.dart';
import 'package:teriak/features/pharmacy/data/repositories/pharmacy_repository_impl.dart';
import 'package:teriak/features/pharmacy/domain/entities/pharmacy_entity.dart';
import 'package:teriak/features/pharmacy/domain/usecases/add_pharmacy.dart';

class AddPharmacyController extends GetxController {
  final Rx<PharmacyEntity?> pharmacy = Rx<PharmacyEntity?>(null);
  final TextEditingController managerFirstNameController =
      TextEditingController();
  final TextEditingController managerLastNameController =
      TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController pharmacyNameController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController managerPasswordController =
      TextEditingController();
  final RxBool isPasswordVisible = false.obs;
  final TextEditingController addressController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController managerEmailController = TextEditingController();

  final RxBool isManagerFirstNameValid = false.obs;
  final RxBool isManagerLastNameValid = false.obs;
  final RxBool isLocationValid = false.obs;
  final RxBool isPhoneValid = false.obs;
  final RxBool isOpeningHoursValid = false.obs;
  final RxBool isEmailValid = false.obs;
  final RxBool isPasswordValid = false.obs;

  // Focus nodes
  final FocusNode managerFirstNameFocus = FocusNode();
  final FocusNode managerLastNameFocus = FocusNode();
  final FocusNode locationFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isDraftSaved = false.obs;
  final Rx<TimeOfDay?> openingTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> closingTime = Rx<TimeOfDay?>(null);

  late final NetworkInfoImpl networkInfo;
  late final AddPharmacy _addPharmacy;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _initializeDependencies();
    setupFormListeners();
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String formatTimeForBackend(TimeOfDay? time) {
    if (time == null) return '';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> pickTime(
      {required bool isOpening, BuildContext? context}) async {
    final picked = await showTimePicker(
        context: context!,
        initialTime: TimeOfDay.now(),
        helpText: 'Select time'.tr,
        cancelText: 'Cancel'.tr,
        confirmText: 'OK'.tr);
    if (picked != null) {
      if (isOpening) {
        openingTime.value = picked;
      } else {
        closingTime.value = picked;
      }
      updateFormProgress();
    }
  }

  void setupFormListeners() {
    managerFirstNameController.addListener(updateFormProgress);
    managerLastNameController.addListener(updateFormProgress);
    locationController.addListener(updateFormProgress);
    phoneController.addListener(updateFormProgress);
    emailController.addListener(updateFormProgress);
    passwordController.addListener(updateFormProgress);
  }

  void updateFormProgress() {
    isManagerFirstNameValid.value =
        managerFirstNameController.text.trim().length >= 3;
    isManagerLastNameValid.value =
        managerLastNameController.text.trim().length >= 3;
    isLocationValid.value = locationController.text.trim().length >= 10;
    isPhoneValid.value = phoneController.text.trim().length >= 10;
    isOpeningHoursValid.value = openingTime.value != null &&
        closingTime.value != null &&
        (openingTime.value!.hour < closingTime.value!.hour ||
            (openingTime.value!.hour == closingTime.value!.hour &&
                openingTime.value!.minute < closingTime.value!.minute));
    isEmailValid.value = _isValidEmail(emailController.text.trim());
    isPasswordValid.value = passwordController.text.trim().length >= 6;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  int getCurrentStep() {
    if (!isManagerFirstNameValid.value) return 0; // Basic Info
    if (!isManagerLastNameValid.value) return 1; // Last Name
    if (!isLocationValid.value) return 2; // Location
    if (!isPhoneValid.value) return 3; // Contact
    if (!isOpeningHoursValid.value) return 4; // Opening Hours
    if (!isEmailValid.value) return 5; // Credentials
    if (!isPasswordValid.value) return 6; // Password
    return 7; // Complete
  }

  double getProgress() {
    int step = getCurrentStep();
    int totalSteps = 7;
    return step / totalSteps;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void _initializeDependencies() {
    final cacheHelper = CacheHelper();
    networkInfo = NetworkInfoImpl();
    final httpConsumer =
        HttpConsumer(baseUrl: EndPoints.baserUrl, cacheHelper: cacheHelper);

    final remoteDataSource = PharmacyRemoteDataSource(api: httpConsumer);

    final repository = PharmacyRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    _addPharmacy = AddPharmacy(repository: repository);
  }

  Future<bool> onWillPop(BuildContext? context) async {
    if (managerFirstNameController.text.isNotEmpty ||
        managerLastNameController.text.isNotEmpty ||
        locationController.text.isNotEmpty ||
        phoneController.text.isNotEmpty ||
        openingTime.value != null ||
        closingTime.value != null ||
        emailController.text.isNotEmpty ||
        passwordController.text.isNotEmpty) {
      return await showDialog<bool>(
            context: context!,
            builder: (context) => AlertDialog(
              title: Text('Discard Changes?'.tr),
              content: Text(
                  'You have unsaved changes. Do you want to discard them?'.tr),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'.tr),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Discard'.tr),
                ),
              ],
            ),
          ) ??
          false;
    }
    return true;
  }

  Future<void> addPharmacy() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      print('🌐 Testing network connectivity...');
      final isConnected = await networkInfo.isConnected;
      print('📡 Network connected: $isConnected');
      if (!isConnected) {
        errorMessage.value =
            'No internet connection. Please check your network.'.tr;
        Get.snackbar('Error', errorMessage.value);
        return;
      }
      String openingHoursString = '';
      if (openingTime.value != null && closingTime.value != null) {
        final openingFormatted = formatTimeForBackend(openingTime.value);
        final closingFormatted = formatTimeForBackend(closingTime.value);
        openingHoursString = '$openingFormatted - $closingFormatted';
      }
      if (emailController.text.trim().isEmpty) {
        errorMessage.value = 'Email is required'.tr;
        Get.snackbar(
          'Error'.tr,
          errorMessage.value,
        );
        return;
      }

      if (openingTime.value == null || closingTime.value == null) {
        errorMessage.value = 'Please select both opening and closing times'.tr;
        Get.snackbar(
          'Error'.tr,
          errorMessage.value,
        );
        return;
      }

      final pharmacyParams = PhaParams(
        passwordController.text.trim(), // newPassword
        locationController.text.trim(), // location
        managerFirstNameController.text.trim(), // managerFirstName
        managerLastNameController.text.trim(), // managerLastName
        phoneController.text.trim(), // pharmacyPhone
        emailController.text.trim(), // pharmacyEmail
        openingHoursString, // openingHours
      );

      print('🔍 Created PhaParams:');
      print('  - newPassword: ${pharmacyParams.newPassword}');
      print('  - location: ${pharmacyParams.location}');
      print('  - managerFirstName: ${pharmacyParams.managerFirstName}');
      print('  - managerLastName: ${pharmacyParams.managerLastName}');
      print('  - pharmacyPhone: ${pharmacyParams.pharmacyPhone}');
      print('  - pharmacyEmail: ${pharmacyParams.pharmacyEmail}');
      print('  - openingHours: ${pharmacyParams.openingHours}');
      print('-------------openingHours: $openingHoursString');
      final result = await _addPharmacy(pharmacyParams);
      result.fold((failure) {
        print('❌ Pharmacy addition failed: ${failure.errMessage}');

        errorMessage.value = 'Failed to add pharmacy: ${failure.errMessage}'.tr;
        Get.snackbar('Error', errorMessage.value);

        Get.snackbar(
          'Error'.tr,
          errorMessage.value,
        );
      }, (addedPharmacy) async {
        print('✅ Pharmacy added successfully!');
        print('🆔 Pharmacy ID: ${addedPharmacy.id}');
        print('🏥 Pharmacy Name: ${addedPharmacy.pharmacyName}');
        pharmacy.value = addedPharmacy;

        final cacheHelper = CacheHelper();
        await cacheHelper.saveData(
            key: 'isPharmacyRegistrationComplete', value: true);

        Get.offNamed(AppPages.moneyBox);

        managerFirstNameController.clear();
        managerLastNameController.clear();
        locationController.clear();
        phoneController.clear();
        emailController.clear();
        passwordController.clear();
        openingTime.value = null;
        closingTime.value = null;
      });
    } catch (e) {
      print('💥 Unexpected error: $e');
      errorMessage.value = 'An unexpected error occurred. Please try again.'.tr;

      Get.snackbar(
        'Error'.tr,
        errorMessage.value,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    managerFirstNameController.dispose();
    managerLastNameController.dispose();
    locationController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();

    managerFirstNameFocus.dispose();
    managerLastNameFocus.dispose();
    locationFocus.dispose();
    phoneFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();

    super.onClose();
  }
}
