import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.sizeOf(context).height / 15),
              Center(
                child: Image.asset(
                  "assets/images/just_logo.png",
                  scale: 10,
                ),
              ),
              SizedBox(height: 6.h),

              // Welcome Text
              Text(
                'Welcome Pharmacy',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 1.h),

              Text(
                'Sign in to your pharmacy account',
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
