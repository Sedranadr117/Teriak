import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/features/products/product_data/data/models/product_data_model.dart';

void showMultiSelectBottomSheet({
  required String title,
  required List<ProductDataModel> items,
  required List<int> selectedIds,
  required Function(List<int>) onSelectionChanged,
}) {
  final tempSelected = List<int>.from(selectedIds);

  Get.bottomSheet(
    Container(
      constraints: BoxConstraints(
        maxHeight: Get.height * 0.6,
      ),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                            Get.theme.colorScheme.onSurface, 
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = tempSelected.contains(item.id);
                    return CheckboxListTile(
                      title: Text(item.name),
                      value: isSelected,
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true) {
                            tempSelected.add(item.id);
                          } else {
                            tempSelected.remove(item.id);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  onSelectionChanged(tempSelected);
                  Get.back();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      ),
    ),
    isScrollControlled: true,
  );
}
