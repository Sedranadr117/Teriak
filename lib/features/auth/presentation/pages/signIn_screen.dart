import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/localization/locale_controller.dart';
import 'package:teriak/features/auth/presentation/controllers/auth_controller.dart';
import 'package:teriak/features/auth/presentation/pages/widgets/signIn_form_widget.dart';
import 'package:teriak/features/settings/presentation/widgets/settings_item_widget.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final AuthController authController = Get.put(AuthController());
  final LocaleController _localeController = Get.find<LocaleController>();
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
                          const SnackBar(
                              content: Text('Language changed to \$language')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.sizeOf(context).height / 15),
              Obx(() => SettingsItemWidget(
                    icon: 'language',
                    title: 'Language',
                    subtitle:
                        _localeController.isArabic ? 'العربية' : 'English',
                    onTap: () => _showLanguageDialog(context),
                    showArrow: true,
                  )),
              Center(
                child: Image.asset(
                  "assets/images/just_logo.png",
                  scale: 10,
                ),
              ),
              SizedBox(height: 6.h),

              // Welcome Text
              Text(
                'Welcome Pharmacy'.tr,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 1.h),

              Text(
                'Sign in to your pharmacy account'.tr,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 4.h),

              // Error Message
              Obx(
                () => Column(
                  children: [
                    if (authController.errorMessage.value.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .error
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Theme.of(context).colorScheme.error,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                authController.errorMessage.value,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 3.h),
                  ],
                ),
              ),

              // Login Form
              Obx(() {
                print('------------' + authController.errorMessage.value);

                return LoginFormWidget(
                  formKey: authController.formKey,
                  emailController: authController.emailController,
                  passwordController: authController.passwordController,
                  isPasswordVisible: authController.isPasswordVisible.value,
                  isLoading: authController.isLoading.value,
                  onTogglePasswordVisibility:
                      authController.togglePasswordVisibility,
                  onSignIn: authController.login,
                );
              }),

              SizedBox(height: 20.h),
              // Footer
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Text(
                  'TIRYAQ Manager v1.0.0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
