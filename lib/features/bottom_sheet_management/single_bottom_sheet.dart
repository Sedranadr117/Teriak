import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/features/products/product_data/data/models/product_data_model.dart';


void showDropdownBottomSheet({
  required String title,
  required List<ProductDataModel> items,
  required Function(int id, String name) onSelected,
}) {
  Get.bottomSheet(
    Container(
      constraints: BoxConstraints(
        maxHeight: Get.height * 0.6,
      ),
      decoration:  BoxDecoration(
        color: Get.theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(Get.height * 0.04),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Get.theme.colorScheme.outline.withOpacity(0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.name),
                  onTap: () {
                    onSelected(item.id, item.name);
                    Get.back();
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}
