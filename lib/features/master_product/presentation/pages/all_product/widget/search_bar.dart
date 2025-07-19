import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/config/themes/app_theme.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedSearchFilter = 'tradeName';

  final List<Map<String, String>> _searchFilterOptions = [
    {'value': 'tradeName', 'label': 'Trade Name'},
    {'value': 'scientificName', 'label': 'Scientific Name'},
    {'value': 'barcode', 'label': 'Barcode'},
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
          horizontal: 4 * context.w / 100, vertical: 2 * context.h / 100),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.borderLight,
                  width: 1,
                ),
              ),
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products'.tr,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      /*?.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),*/,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3 * context.w / 100),
                    child: const CustomIconWidget(
                      iconName: 'search',
                      color: AppColors.textSecondaryLight,
                      size: 20,
                    ),
                  ),
                  suffixIcon: null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4 * context.w / 100,
                    vertical: 1.5 * context.h / 100,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 3 * context.w / 100),
          // Search Filter Dropdown
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3 * context.w / 100),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryLight,
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSearchFilter,
                icon: const CustomIconWidget(
                  iconName: 'arrow_drop_down',
                  color: AppColors.onPrimaryLight,
                  size: 20,
                ),
                style:
                    Theme.of(context).textTheme.bodySmall/*?.copyWith(
                          color: AppColors.onPrimaryLight,
                          fontWeight: FontWeight.w500,
                        ),*/,
                dropdownColor: Colors.white,
                items: _searchFilterOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option['value'],
                    child: Text(
                      option['label']!.tr,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          /*?.copyWith(
                            color: AppColors.onPrimaryLight,
                            fontWeight: FontWeight.w500,
                          ),*/
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedSearchFilter = value;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
