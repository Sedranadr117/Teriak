import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/bottom_sheet_management/barcode_bottom_sheet.dart';
import 'package:teriak/features/products/search_product/presentation/controller/search_product_controller.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final searchController = Get.find<SearchProductController>();

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
                controller: searchController.searchController,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    searchController.search(value.trim());
                  } else {
                    searchController.results.clear();
                    searchController.searchStatus.value = null;
                  }
                },
                focusNode: searchController.searchFocus,
                decoration: InputDecoration(
                  hintText: 'Search products'.tr,
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3 * context.w / 100),
                    child: const CustomIconWidget(
                      iconName: 'search',
                      color: AppColors.textSecondaryLight,
                      size: 20,
                    ),
                  ),
                  suffixIcon: IconButton(
                    padding: EdgeInsets.all(context.w * 0.03),
                    icon: CustomIconWidget(
                      iconName: 'qr_code',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onPressed: () async {
                      await showBarcodeScannerBottomSheet(
                        onScanned: (code) {
                          searchController.searchController.text = code;
                          searchController.search(code);
                        },
                      );
                    },
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
