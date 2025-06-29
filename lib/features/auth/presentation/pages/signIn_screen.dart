import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/core/themes/app_theme.dart';
import 'package:teriak/features/auth/presentation/controllers/auth_controller.dart';
import 'package:teriak/features/auth/presentation/pages/widgets/signIn_form_widget.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                children: [
                  SizedBox(height: 8.h),
                  Center(
                    child: Image.asset(
                      "assets/images/just_logo.png",
                      scale: 10,
                    ),
                  ),
                  SizedBox(height: 6.h),

                  // Welcome Text
                  Text(
                    'Welcome Back',
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 1.h),

                  Text(
                    'Sign in to manage your pharmacy operations',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
                              color: AppTheme.lightTheme.colorScheme.error
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.lightTheme.colorScheme.error
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Text(
                                    authController.errorMessage.value,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color:
                                          AppTheme.lightTheme.colorScheme.error,
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

                  const Spacer(),

                  // Footer
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Text(
                      'TIRYAQ Manager v1.0.0',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
