import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/theme_controller.dart';
import 'package:teriak/config/widgets/custom_app_bar.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';

import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/features/settings/presentation/widgets/simple_loading_widget.dart';
import '../widgets/settings_item_widget.dart';
import '../widgets/settings_section_widget.dart';
import '../widgets/user_profile_header_widget.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import '../controllers/user_profile_controller.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final ThemeController _themeController = Get.find<ThemeController>();
  final LocaleController _localeController = Get.find<LocaleController>();
  late UserProfileController _userProfileController;

  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _userProfileController = Get.put(UserProfileController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showThemeToggle: false,
        title: 'Settings'.tr,
        actions: [
          IconButton(
            onPressed: () => _userProfileController.refreshUserProfile(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Profile'.tr,
          ),
        ],
      ),
      body: Obx(() {
        final userData = _userProfileController.getUserDataMap();
        return SingleChildScrollView(
          child: Column(
            children: [
              _userProfileController.isLoading.value
                  ? SimpleLoadingWidget(
                      message: 'Loading Profile...'.tr,
                    )
                  : UserProfileHeaderWidget(
                      userData: userData,
                    ),
              SizedBox(height: 2.h),

              // Pharmacy Preferences Section
              SettingsSectionWidget(
                title: 'Pharmacy Preferences'.tr,
                children: [
                  SettingsItemWidget(
                    icon: 'notifications',
                    title: 'Notifications'.tr,
                    subtitle: 'Manage pharmacy alerts and updates'.tr,
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),
              // App Configuration Section
              SettingsSectionWidget(
                title: 'App Configuration'.tr,
                children: [
                  Obx(() => SettingsItemWidget(
                        icon: 'language',
                        title: 'Language'.tr,
                        subtitle:
                            _localeController.isArabic ? 'العربية' : 'English',
                        onTap: () => _showLanguageDialog(context),
                        showArrow: true,
                      )),
                  Obx(() => SettingsItemWidget(
                        icon: 'palette',
                        title: 'Theme'.tr,
                        subtitle: _themeController.isDarkMode
                            ? 'Dark'.tr
                            : 'Light'.tr,
                        trailing: Switch(
                          value: _themeController.isDarkMode,
                          onChanged: (value) {
                            _themeController.toggleTheme();
                          },
                        ),
                      )),
                ],
              ),

              SizedBox(height: 2.h),

              // Sign Out Button
              Container(
                width: 90.w,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                child: ElevatedButton(
                  onPressed: () => _showSignOutDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorLight,
                    foregroundColor: AppColors.onErrorLight,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomIconWidget(
                        iconName: 'logout',
                        color: AppColors.onErrorLight,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Sign Out'.tr,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.onErrorLight,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 4.h),
            ],
          ),
        );
      }),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languages = [
      {'label': 'English', 'code': 'en_US'},
      {'label': 'العربية', 'code': 'ar_SY'},
    ];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Language'.tr,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: SizedBox(
          width: 80.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages
                .map((lang) => Obx(() => RadioListTile<String>(
                      title: Text(lang['label']!),
                      value: lang['code']!,
                      groupValue:
                          _localeController.isArabic ? 'ar_SY' : 'en_US',
                      onChanged: (value) async {
                        await _localeController.changeLocale(value!);
                        Navigator.pop(context);
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: _localeController.isArabic
                                  ? Text('Language changed to Arabic'.tr)
                                  : Text('Language changed to English'.tr)),
                        );
                      },
                    )))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'.tr),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Contact Support'.tr,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get in touch with our support team:'.tr,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'email',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'support@tiryaq.com',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'phone',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  '+1 (555) 123-4567',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  '24/7 Support Available',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening email client...'.tr)),
              );
            },
            child: Text('Send Email'.tr),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sign Out'.tr,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to sign out? You will need to sign in again to access your account.'
              .tr,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final cacheHelper = CacheHelper();
              await cacheHelper.removeData(key: 'token');
              await cacheHelper.removeData(key: 'Role');
              Get.offAllNamed(AppPages.signin);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Signed out successfully'.tr)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorLight,
              foregroundColor: AppColors.onErrorLight,
            ),
            child: Text('Sign Out'.tr),
          ),
        ],
      ),
    );
  }
}
