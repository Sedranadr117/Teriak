import 'package:flutter/material.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';

class InfoDetailsCardWidget extends StatelessWidget {
  final String title;
  final Widget child;

  const InfoDetailsCardWidget({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: context.w * 0.04,
        vertical: context.w * 0.01,
      ),
      padding: EdgeInsets.all(context.w * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: context.h * 0.02,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryLight,
            ),
          ),
          SizedBox(height: context.w * 0.02),
          child,
        ],
      ),
    );
  }
}
