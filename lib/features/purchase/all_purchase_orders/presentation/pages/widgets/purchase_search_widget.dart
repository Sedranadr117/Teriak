import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';

class PurchaseSearchWidget extends StatefulWidget {
 

  const PurchaseSearchWidget({
    super.key,

  });

  @override
  State<PurchaseSearchWidget> createState() => _PurchaseSearchWidgetState();
}

class _PurchaseSearchWidgetState extends State<PurchaseSearchWidget> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocus = FocusNode();

  @override
  void dispose() {
    searchController.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      padding: EdgeInsets.symmetric(
          horizontal: 4 * context.w / 100, vertical: 2 * context.h / 100),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.backgroundDark
                    : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.backgroundDark
                      : AppColors.backgroundLight,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: searchController,
                onSubmitted: (value) {
                  // if (value.trim().isNotEmpty) {
                  //   widget.onSearchChanged(value.trim());
                  // } else {
                  //   widget.onSearchChanged('');
                  //   if (widget.onClear != null) {
                  //     widget.onClear!();
                  //   }
                  // }
                },
             
                focusNode: searchFocus,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: 'Search purchase orders'.tr,
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  prefixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            // searchController.clear();
                            // widget.onSearchChanged('');
                            // if (widget.onClear != null) {
                            //   widget.onClear!();
                            // }
                            // setState(() {});
                          },
                          icon: const CustomIconWidget(
                            iconName: 'clear',
                            color: AppColors.textSecondaryLight,
                            size: 20,
                          ),
                        )
                      : null,
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(3 * context.w / 100),
                    child: const CustomIconWidget(
                      iconName: 'search',
                      color: AppColors.textSecondaryLight,
                      size: 20,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4 * context.w / 100,
                    vertical: 1.5 * context.h / 100,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
