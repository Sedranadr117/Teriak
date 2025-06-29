import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/core/custom_icon_widget.dart';
import 'package:teriak/core/themes/app_theme.dart';

class LoginFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final bool isLoading;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onSignIn;

  const LoginFormWidget({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.isLoading,
    required this.onTogglePasswordVisibility,
    required this.onSignIn,
  });

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (value.trim().length < 3) {
      return 'Email must be at least 10 characters';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Username Field
          TextFormField(
            controller: emailController,
            enabled: !isLoading,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            validator: _validateEmail,
            decoration: InputDecoration(
              labelText: 'E-mail',
              hintText: 'Enter your email',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'person_outline',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Password Field
          TextFormField(
            controller: passwordController,
            enabled: !isLoading,
            obscureText: !isPasswordVisible,
            textInputAction: TextInputAction.done,
            validator: _validatePassword,
            onFieldSubmitted: (_) => onSignIn(),
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock_outline',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: isLoading ? null : onTogglePasswordVisibility,
                icon: CustomIconWidget(
                  iconName: isPasswordVisible ? 'visibility_off' : 'visibility',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Sign In Button
          SizedBox(
            height: 6.h,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSignIn,
              child: isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Signing In...',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Sign In',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          // SizedBox(height: 3.h),

          // Demo Credentials Info
          // Container(
          //   padding: EdgeInsets.all(3.w),
          //   decoration: BoxDecoration(
          //     color: AppTheme.lightTheme.colorScheme.primaryContainer
          //         .withValues(alpha: 0.1),
          //     borderRadius: BorderRadius.circular(12),
          //     border: Border.all(
          //       color: AppTheme.lightTheme.colorScheme.primary
          //           .withValues(alpha: 0.2),
          //     ),
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Row(
          //         children: [
          //           CustomIconWidget(
          //             iconName: 'info_outline',
          //             color: AppTheme.lightTheme.colorScheme.primary,
          //             size: 16,
          //           ),
          //           SizedBox(width: 2.w),
          //           Text(
          //             'Demo Credentials',
          //             style:
          //                 AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          //               color: AppTheme.lightTheme.colorScheme.primary,
          //               fontWeight: FontWeight.w600,
          //             ),
          //           ),
          //         ],
          //       ),
          //       SizedBox(height: 1.h),
          //       Text(
          //         'admin / admin123\npharmacy_admin / pharma2024\nmanager / manager456',
          //         style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          //           color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          //           fontFamily: 'monospace',
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
