import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';

class AccountSetupCard extends StatefulWidget {
  final TextEditingController passwordController;
  final Function(String strength)? onStrengthChanged;

  const AccountSetupCard({
    Key? key,
    required this.passwordController,
    this.onStrengthChanged,
  }) : super(key: key);

  @override
  State<AccountSetupCard> createState() => _AccountSetupCardState();
}

class _AccountSetupCardState extends State<AccountSetupCard> {
  bool _isPasswordVisible = false;
  String _passwordStrength = '';
  Color _strengthColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    widget.passwordController.addListener(_checkPasswordStrength);
  }

  void _checkPasswordStrength() {
    final password = widget.passwordController.text;

    if (password.isEmpty) {
      setState(() {
        _passwordStrength = '';
        _strengthColor = Colors.grey;
      });
      widget.onStrengthChanged?.call('');
      return;
    }

    int score = 0;

    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    setState(() {
      if (score <= 2) {
        _passwordStrength = 'Weak';
        _strengthColor = AppColors.errorLight;
      } else if (score <= 4) {
        _passwordStrength = 'Medium';
        _strengthColor = AppColors.warningLight;
      } else {
        _passwordStrength = 'Strong';
        _strengthColor = AppColors.successLight;
      }
    });

    widget.onStrengthChanged?.call(_passwordStrength);
  }

  @override
  void dispose() {
    widget.passwordController.removeListener(_checkPasswordStrength);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'lock',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Account Setup'.tr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            SizedBox(height: 4.w),
            TextFormField(
              controller: widget.passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password'.tr,
                hintText: 'Create a secure password'.tr,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'lock_outline',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  icon: CustomIconWidget(
                    iconName:
                        _isPasswordVisible ? 'visibility_off' : 'visibility',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Password is required'.tr;
                }
                if (value.trim().length < 6) {
                  return 'Password must be at least 6 characters'.tr;
                }
                return null;
              },
            ),
            if (_passwordStrength.isNotEmpty) ...[
              SizedBox(height: 2.w),
              Row(
                children: [
                  Text(
                    'Password Strength: '.tr,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    _passwordStrength,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _strengthColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 1.w),
              LinearProgressIndicator(
                value: _passwordStrength == 'Weak'.tr
                    ? 0.33
                    : _passwordStrength == 'Medium'.tr
                        ? 0.66
                        : 1.0,
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(_strengthColor),
              ),
            ],
            SizedBox(height: 3.w),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Password Requirements:'.tr,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  SizedBox(height: 1.w),
                  _buildRequirement('At least 6 characters'.tr,
                      widget.passwordController.text.length >= 6),
                  _buildRequirement(
                      'Contains uppercase letter'.tr,
                      widget.passwordController.text
                          .contains(RegExp(r'[A-Z]'))),
                  _buildRequirement(
                      'Contains lowercase letter'.tr,
                      widget.passwordController.text
                          .contains(RegExp(r'[a-z]'))),
                  _buildRequirement(
                    'Contains number'.tr,
                    widget.passwordController.text.contains(RegExp(r'[0-9]')),
                  ),
                  _buildRequirement(
                      'Contains special character'.tr,
                      widget.passwordController.text
                          .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.w),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: isMet ? 'check_circle' : 'radio_button_unchecked',
            color: isMet
                ? AppColors.successLight
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isMet
                      ? AppColors.successLight
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
