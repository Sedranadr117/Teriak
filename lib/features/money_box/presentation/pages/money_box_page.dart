import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/features/money_box/presentation/controller/add_money_box_controlller.dart';
import 'package:teriak/features/money_box/presentation/controller/get_money_box_controlller.dart';
import 'package:teriak/features/money_box/presentation/pages/money_box_info_page.dart';
import 'package:teriak/features/suppliers/all_supplier/presentation/controller/all_supplier_controller.dart';

class MoneyBoxPage extends StatefulWidget {
  const MoneyBoxPage({super.key});

  @override
  State<MoneyBoxPage> createState() => _MoneyBoxPageState();
}

class _MoneyBoxPageState extends State<MoneyBoxPage> {
  final openBoxController = Get.put(AddMoneyBoxController());
  final getMoneyBoxController = Get.put(GetMoneyBoxController());

  @override
  void initState() {
    super.initState();
    getMoneyBoxController.getMoneyBoxData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (getMoneyBoxController.isLoading.value) {
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      if (getMoneyBoxController.moneyBox.value == null) {
        return _buildOpenBoxView();
      } else {
        return const MoneyBoxInfoPage();
      }
    });
  }

  Widget _buildOpenBoxView() {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: Obx(() {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: openBoxController.isFormVisible.value
                        ? _buildForm(openBoxController)
                        : _buildInitialView(openBoxController),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
  Widget _buildInitialView(AddMoneyBoxController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(60),
            border: Border.all(
              color: AppColors.primaryLight.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Icon(
            Icons.account_balance_wallet,
            size: 60,
            color: AppColors.primaryLight,
          ),
        ),
        const SizedBox(height: 32),

        // Title
        Text(
          'Money Box'.tr,
          style: Get.textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimaryLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // Description
        Text(
          'Click here to open money box for the first time'.tr,
          textAlign: TextAlign.center,
          style: Get.textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondaryLight,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 48),

        // Open Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.showForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
              foregroundColor: AppColors.onPrimaryLight,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  size: 24,
                  color: AppColors.onPrimaryLight,
                ),
                const SizedBox(width: 12),
                Text(
                  'Open Money Box'.tr,
                  style: Get.textTheme.titleMedium?.copyWith(
                    color: AppColors.onPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildForm(AddMoneyBoxController controller) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  // ألوان حسب الثيم
  final fillColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
  final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
  final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
  final hintColor = isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight;
  final iconColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
  final primaryColor = isDark ? AppColors.primaryDark : AppColors.primaryLight;
  final errorColor = isDark ? AppColors.errorDark : AppColors.errorLight;
  final errorBackground = errorColor.withOpacity(0.1);
  final errorBorderColor = errorColor.withOpacity(0.3);

  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            IconButton(
              onPressed: controller.hideForm,
              icon: Icon(
                Icons.arrow_back,
                color: textColor,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Open Money Box'.tr,
              style: Get.textTheme.headlineSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Initial Balance Field
        Text(
          'Initial Balance'.tr,
          style: Get.textTheme.titleMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller.initialBalanceController,
            keyboardType: TextInputType.number,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: 'Enter initial balance'.tr,
              hintStyle: TextStyle(color: hintColor),
              prefixIcon: Icon(Icons.attach_money, color: iconColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
              filled: true,
              fillColor: fillColor,
            ),
            onChanged: (value) => controller.clearError(),
          ),
        ),
        const SizedBox(height: 24),

        // Currency Selection
        Text(
          'Currency'.tr,
          style: Get.textTheme.titleMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Container(
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: DropdownButtonFormField<String>(
                value: controller.selectedCurrency.value,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: fillColor,
                ),
                style: TextStyle(color: textColor),
                items: controller.currencyOptions.map((currency) {
                  return DropdownMenuItem<String>(
                    value: currency,
                    child: Row(
                      children: [
                        Text(
                          currency,
                          style: Get.textTheme.bodyLarge?.copyWith(
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          currency == 'USD' ? 'USD'.tr : 'SYP'.tr,
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: iconColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.setCurrency(value);
                    controller.clearError();
                  }
                },
              ),
            )),
        const SizedBox(height: 32),

        // Error Message
        Obx(() => controller.errorMessage.value.isNotEmpty
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: errorBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: errorBorderColor),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: errorColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.errorMessage.value,
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: errorColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink()),
        const SizedBox(height: 24),

        // Submit Button
        SizedBox(
          width: double.infinity,
          child: Obx(() => ElevatedButton(
                onPressed:
                    controller.isLoading.value ? null : controller.openMoneyBox,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: AppColors.onPrimaryLight,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: controller.isLoading.value
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.onPrimaryLight),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check,
                            size: 24,
                            color: AppColors.onPrimaryLight,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Open Box'.tr,
                            style: Get.textTheme.titleMedium?.copyWith(
                              color: AppColors.onPrimaryLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              )),
        ),
      ],
    ),
  );
}

}
