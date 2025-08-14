import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/config/themes/theme_controller.dart';
import 'package:teriak/config/widgets/custom_app_bar.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';

import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/features/purchase/all_purchase_orders/presentation/pages/purchase_order_list.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/pages/supplier_list_screen.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/user_profile_header_widget.dart';
import 'package:teriak/config/localization/locale_controller.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final ThemeController _themeController = Get.find<ThemeController>();
  final LocaleController _localeController = Get.find<LocaleController>();
  bool _biometricEnabled = false;
  bool _notificationsEnabled = true;
  bool _offlineStorageEnabled = true;
  bool _developerOptionsEnabled = false;
  //String _selectedLanguage = 'English';
  int _sessionTimeout = 30;

  final List<Map<String, dynamic>> _mockUserData = [
    {
      "id": 1,
      "name": "Dr. Sarah Johnson",
      "email": "sarah.johnson@tiryaq.com",
      "role": "Pharmacy Administrator",
      "avatar": "",
      "pharmacyCount": 3,
      "lastLogin": "2024-01-15 09:30 AM"
    }
  ];

  @override
  Widget build(BuildContext context) {
    final userData = _mockUserData.first;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Settings',
        actions: [
          GestureDetector(
              onTap: () {
                Get.toNamed(AppPages.allProductPage);
              },
              child: CustomIconWidget(iconName: "add")),
          GestureDetector(
              onTap: () {
                Get.to(SupplierListScreen());
              },
              child: CustomIconWidget(iconName: "setting")),
          GestureDetector(
              onTap: () {
                Get.toNamed(AppPages.purchaseOrderList);
              },
              child: CustomIconWidget(iconName: "car_crash")),
          GestureDetector(
              onTap: () {
                Get.toNamed(AppPages.purchaseOrderDetail);
              },
              child: CustomIconWidget(iconName: "dangerous")),
        ],
        showThemeToggle:
            false, // Don't show theme toggle in settings since it's already there
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // User Profile Header
            UserProfileHeaderWidget(
              userData: userData,
            ),

            SizedBox(height: 2.h),

            // Account Settings Section
            SettingsSectionWidget(
              title: 'Account Settings',
              children: [
                SettingsItemWidget(
                  icon: 'person',
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () => _showComingSoonDialog(context, 'Edit Profile'),
                  showArrow: true,
                ),
                SettingsItemWidget(
                  icon: 'lock',
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  onTap: () => _showPasswordChangeDialog(context),
                  showArrow: true,
                ),
                SettingsItemWidget(
                  icon: 'fingerprint',
                  title: 'Biometric Authentication',
                  subtitle: 'Use fingerprint or face recognition',
                  trailing: Switch(
                    value: _biometricEnabled,
                    onChanged: (value) {
                      setState(() {
                        _biometricEnabled = value;
                      });
                      _showBiometricSetupDialog(context, value);
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Pharmacy Preferences Section
            SettingsSectionWidget(
              title: 'Pharmacy Preferences',
              children: [
                SettingsItemWidget(
                  icon: 'store',
                  title: 'Default Pharmacy Location',
                  subtitle: 'Set your primary pharmacy',
                  onTap: () => _showComingSoonDialog(
                      context, 'Default Pharmacy Location'),
                  showArrow: true,
                ),
                SettingsItemWidget(
                  icon: 'notifications',
                  title: 'Notifications',
                  subtitle: 'Manage pharmacy alerts and updates',
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                ),
                SettingsItemWidget(
                  icon: 'sync',
                  title: 'Sync Frequency',
                  subtitle: 'Auto-sync every 15 minutes',
                  onTap: () => _showSyncFrequencyDialog(context),
                  showArrow: true,
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Security Options Section
            SettingsSectionWidget(
              title: 'Security Options',
              children: [
                SettingsItemWidget(
                  icon: 'timer',
                  title: 'Session Timeout',
                  subtitle: '\$_sessionTimeout minutes',
                  onTap: () => _showSessionTimeoutDialog(context),
                  showArrow: true,
                ),
                SettingsItemWidget(
                  icon: 'security',
                  title: 'Login Requirements',
                  subtitle: 'Manage authentication settings',
                  onTap: () =>
                      _showComingSoonDialog(context, 'Login Requirements'),
                  showArrow: true,
                ),
                const SettingsItemWidget(
                  icon: 'enhanced_encryption',
                  title: 'Data Encryption',
                  subtitle: 'Enabled - AES 256-bit encryption',
                  trailing: CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppColors.successLight,
                    size: 20,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // App Configuration Section
            SettingsSectionWidget(
              title: 'App Configuration',
              children: [
                Obx(() => SettingsItemWidget(
                      icon: 'language',
                      title: 'Language',
                      subtitle:
                          _localeController.isArabic ? 'العربية' : 'English',
                      onTap: () => _showLanguageDialog(context),
                      showArrow: true,
                    )),
                Obx(() => SettingsItemWidget(
                      icon: 'palette',
                      title: 'Theme',
                      subtitle: _themeController.isDarkMode ? 'Dark' : 'Light',
                      trailing: Switch(
                        value: _themeController.isDarkMode,
                        onChanged: (value) {
                          _themeController.toggleTheme();
                        },
                      ),
                    )),
                SettingsItemWidget(
                  icon: 'storage',
                  title: 'Offline Storage',
                  subtitle: 'Store data for offline access',
                  trailing: Switch(
                    value: _offlineStorageEnabled,
                    onChanged: (value) {
                      setState(() {
                        _offlineStorageEnabled = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Developer Options Section
            if (_developerOptionsEnabled)
              SettingsSectionWidget(
                title: 'Developer Options',
                children: [
                  SettingsItemWidget(
                    icon: 'api',
                    title: 'API Endpoints',
                    subtitle: 'Configure server endpoints',
                    onTap: () =>
                        _showComingSoonDialog(context, 'API Endpoints'),
                    showArrow: true,
                  ),
                  SettingsItemWidget(
                    icon: 'bug_report',
                    title: 'Debug Logging',
                    subtitle: 'Enable detailed logging',
                    onTap: () =>
                        _showComingSoonDialog(context, 'Debug Logging'),
                    showArrow: true,
                  ),
                ],
              ),

            // Developer Options Toggle
            SettingsSectionWidget(
              title: 'Advanced',
              children: [
                SettingsItemWidget(
                  icon: 'developer_mode',
                  title: 'Developer Options',
                  subtitle: 'Enable advanced settings',
                  trailing: Switch(
                    value: _developerOptionsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _developerOptionsEnabled = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Help & Support Section
            SettingsSectionWidget(
              title: 'Help & Support',
              children: [
                SettingsItemWidget(
                  icon: 'help',
                  title: 'Help Center',
                  subtitle: 'Get help and support',
                  onTap: () => _showComingSoonDialog(context, 'Help Center'),
                  showArrow: true,
                ),
                SettingsItemWidget(
                  icon: 'contact_support',
                  title: 'Contact Support',
                  subtitle: 'support@tiryaq.com',
                  onTap: () => _showContactDialog(context),
                  showArrow: true,
                ),
                SettingsItemWidget(
                  icon: 'info',
                  title: 'App Version',
                  subtitle: 'Version 1.0.0 (Build 100)',
                  onTap: () => _checkForUpdates(context),
                  showArrow: true,
                ),
              ],
            ),

            SizedBox(height: 4.h),

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
                      'Sign Out',
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
      ),
    );
  }

  void _showPasswordChangeDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool obscureCurrentPassword = true;
    bool obscureNewPassword = true;
    bool obscureConfirmPassword = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'Change Password',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: SizedBox(
            width: 80.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: obscureCurrentPassword,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    suffixIcon: IconButton(
                      icon: CustomIconWidget(
                        iconName: obscureCurrentPassword
                            ? 'visibility'
                            : 'visibility_off',
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureCurrentPassword = !obscureCurrentPassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                TextField(
                  controller: newPasswordController,
                  obscureText: obscureNewPassword,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    suffixIcon: IconButton(
                      icon: CustomIconWidget(
                        iconName: obscureNewPassword
                            ? 'visibility'
                            : 'visibility_off',
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureNewPassword = !obscureNewPassword;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    suffixIcon: IconButton(
                      icon: CustomIconWidget(
                        iconName: obscureConfirmPassword
                            ? 'visibility'
                            : 'visibility_off',
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (currentPasswordController.text.isEmpty ||
                    newPasswordController.text.isEmpty ||
                    confirmPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }
                if (newPasswordController.text !=
                    confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('New passwords do not match')),
                  );
                  return;
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Password changed successfully')),
                );
              },
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBiometricSetupDialog(BuildContext context, bool enabled) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          enabled
              ? 'Enable Biometric Authentication'
              : 'Disable Biometric Authentication',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(
          enabled
              ? 'Would you like to enable biometric authentication for secure and quick access to your account?'
              : 'Are you sure you want to disable biometric authentication?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _biometricEnabled = !enabled;
              });
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    enabled
                        ? 'Biometric authentication enabled'
                        : 'Biometric authentication disabled',
                  ),
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
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
          'Select Language',
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
                                  ? Text('Language changed to Arabic')
                                  : Text('Language changed to English')),
                        );
                      },
                    )))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showSessionTimeoutDialog(BuildContext context) {
    final timeouts = [15, 30, 60, 120];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Session Timeout',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: SizedBox(
          width: 80.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: timeouts
                .map((timeout) => RadioListTile<int>(
                      title: const Text('\$timeout minutes'),
                      value: timeout,
                      groupValue: _sessionTimeout,
                      onChanged: (value) {
                        setState(() {
                          _sessionTimeout = value!;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Session timeout set to \$timeout minutes')),
                        );
                      },
                    ))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showSyncFrequencyDialog(BuildContext context) {
    final frequencies = [
      '5 minutes',
      '15 minutes',
      '30 minutes',
      '1 hour',
      'Manual'
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sync Frequency',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: SizedBox(
          width: 80.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: frequencies
                .map((frequency) => ListTile(
                      title: Text(frequency),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Sync frequency set to \$frequency')),
                        );
                      },
                    ))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Contact Support',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get in touch with our support team:',
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
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening email client...')),
              );
            },
            child: const Text('Send Email'),
          ),
        ],
      ),
    );
  }

  void _checkForUpdates(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Check for Updates',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 2.h),
            Text(
              'Checking for updates...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );

    // Simulate update check
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Up to Date',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'You are using the latest version of TIRYAQ Manager.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'.tr),
            ),
          ],
        ),
      );
    });
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sign Out',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to sign out? You will need to sign in again to access your account.',
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
              Get.offAllNamed(AppPages.signin);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorLight,
              foregroundColor: AppColors.onErrorLight,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Coming Soon',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          '\$feature feature is coming soon in the next update.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'.tr),
          ),
        ],
      ),
    );
  }
}
