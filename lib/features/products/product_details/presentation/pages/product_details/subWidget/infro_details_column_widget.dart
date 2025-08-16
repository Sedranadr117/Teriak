import 'package:flutter/material.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';

// ignore: must_be_immutable
class InfoDetailsColumnWidget extends StatefulWidget {
  String iconName;
  String labelName;
  String value;

  InfoDetailsColumnWidget({super.key, required this.iconName,required this.labelName,required this.value});

  @override
  State<InfoDetailsColumnWidget> createState() =>
      _InfoDetailsColumnWidgetState();
}

class _InfoDetailsColumnWidgetState extends State<InfoDetailsColumnWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           CustomIconWidget(
            iconName: widget.iconName,
            color: AppColors.primaryLight,
            size: 20,
          ),
          SizedBox(height: context.w * 0.01),
          Text(
            widget.labelName,
            style: TextStyle(
              fontSize: context.h * 0.009,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondaryLight,
            ),
          ),
          Text(
            widget.value,
            style: TextStyle(
              fontSize: context.h * 0.012,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceLight,
            ),
          ),
        ],
      ),
    );
  }
}
