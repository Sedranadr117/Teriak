import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final Rx<ThemeMode> _themeMode = ThemeMode.light.obs;
  final CacheHelper _cacheHelper = CacheHelper();

  static const String _themeKey = 'theme_mode';

  ThemeMode get themeMode => _themeMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final savedTheme = await _cacheHelper.getData(key: _themeKey);
      if (savedTheme != null) {
        _themeMode.value = _stringToThemeMode(savedTheme);
      }
    } catch (e) {
      print('Error loading theme mode: $e');
    }
  }

  Future<void> toggleTheme() async {
    final newThemeMode =
        _themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    await _setThemeMode(newThemeMode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _setThemeMode(mode);
  }

  Future<void> _setThemeMode(ThemeMode mode) async {
    try {
      _themeMode.value = mode;
      Get.changeThemeMode(mode);
      await _cacheHelper.saveData(
        key: _themeKey,
        value: _themeModeToString(mode),
      );
    } catch (e) {
      print('Error saving theme mode: $e');
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  ThemeMode _stringToThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  bool get isDarkMode => _themeMode.value == ThemeMode.dark;
  bool get isLightMode => _themeMode.value == ThemeMode.light;
}
