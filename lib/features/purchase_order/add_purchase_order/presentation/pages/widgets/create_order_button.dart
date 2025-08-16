import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';

class CreateOrderButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final String buttonText;

  const CreateOrderButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.isEnabled,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w * 0.04),
     child: SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isEnabled ? AppColors.primaryLight : AppColors.textDisabledLight,
          foregroundColor: AppColors.onPrimaryLight,
          elevation: isEnabled ? 4 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: AppColors.textDisabledLight,
          disabledForegroundColor: AppColors.onPrimaryLight.withOpacity(0.6),
          textStyle: TextStyle(fontSize: 14.sp),
        ),
        child: isLoading
            ? SizedBox(
                width: 5.w,
                height: 2.5.h,
                child: CircularProgressIndicator(
                  color: AppColors.onPrimaryLight,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_shopping_cart,
                    size: 5.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    ));
  }
}
