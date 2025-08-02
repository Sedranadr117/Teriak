import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';

class LocaleController extends GetxController {
  static LocaleController get to => Get.find();

  static const String _localeKey = 'app_locale';
  final CacheHelper _cacheHelper = CacheHelper();

  final Rx<Locale> _locale = const Locale('en', 'US').obs;

  Locale get locale => _locale.value;

  @override
  void onInit() {
    super.onInit();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final cached = _cacheHelper.getDataString(key: _localeKey);
    if (cached != null) {
      if (cached == 'ar_SY') {
        _locale.value = const Locale('ar', 'SY');
        Get.updateLocale(_locale.value);
      } else {
        _locale.value = const Locale('en', 'US');
        Get.updateLocale(_locale.value);
      }
    } else {
      // Use device locale on first launch
      final deviceLocale = Get.deviceLocale;
      if (deviceLocale != null && deviceLocale.languageCode == 'ar') {
        _locale.value = const Locale('ar', 'SY');
        Get.updateLocale(_locale.value);
      } else {
        _locale.value = const Locale('en', 'US');
        Get.updateLocale(_locale.value);
      }
    }
  }

  Future<void> changeLocale(String code) async {
    if (code == 'ar_SY') {
      _locale.value = const Locale('ar', 'SY');
    } else {
      _locale.value = const Locale('en', 'US');
    }
    Get.updateLocale(_locale.value);
    await _cacheHelper.saveData(key: _localeKey, value: code);
  }

  bool get isArabic => _locale.value.languageCode == 'ar';
}
