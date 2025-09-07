import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'package:teriak/config/themes/app_icon.dart';

class EmployeeFilterWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const EmployeeFilterWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'key': 'all', 'label': 'All'.tr, 'icon': 'filter_list'},
      {'key': 'active', 'label': 'Active'.tr, 'icon': 'check_circle'},
      {'key': 'inactive', 'label': 'Inactive'.tr, 'icon': 'cancel'},
    ];

    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter['key'];

          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: filter['icon']!,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 14.sp,
                  ),
                  SizedBox(width: 1.w),
                  Flexible(
                    child: Text(
                      filter['label']!,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontSize: 10.sp,
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                    ),
                  ),
                ],
              ),
              onSelected: (selected) {
                onFilterChanged(filter['key']!);
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: Theme.of(context).colorScheme.primary,
              checkmarkColor: Theme.of(context).colorScheme.onPrimary,
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            ),
          );
        },
      ),
    );
  }
}
