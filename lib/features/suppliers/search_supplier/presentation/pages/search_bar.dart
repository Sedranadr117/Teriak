import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/suppliers/search_supplier/presentation/controller/search_supplier_controller.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final searchController = Get.find<SearchSupplierController>();

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
                  hintText: 'Search suppliers'.tr,
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  prefixIcon: Padding(
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
