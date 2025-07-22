import 'package:flutter/material.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';


// ignore: must_be_immutable
class BoxInProductWidget extends StatefulWidget {
  String icon;
  String label;
  String value;

  BoxInProductWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  State<BoxInProductWidget> createState() => _BoxInProductWidgetState();
}

class _BoxInProductWidgetState extends State<BoxInProductWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: context.w * 0.02, vertical: context.h * 0.01),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.cardDark
              : AppColors.cardLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: widget.icon,
                color: AppColors.primaryLight,
                size: 14,
              ),
              SizedBox(width: context.w * 0.01),
              Text(widget.label,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall /*?.copyWith(
                          color: AppColors.textSecondaryLight,*/

                  ),
            ],
          ),
          SizedBox(height: context.h * 0.005),
          Text(
            widget.value,
            style: Theme.of(context)
                .textTheme
                .bodySmall /*?.copyWith(
                  color: AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w500,
                ),*/
            ,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
