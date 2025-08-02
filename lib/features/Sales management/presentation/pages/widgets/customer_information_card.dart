import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class CustomerInformationCard extends StatefulWidget {
  final TextEditingController customerNameController;

  const CustomerInformationCard({
    super.key,
    required this.customerNameController,
  });

  @override
  State<CustomerInformationCard> createState() =>
      _CustomerInformationCardState();
}

class _CustomerInformationCardState extends State<CustomerInformationCard> {
  int selectedName = 0;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'person',
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Customer Information'.tr,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        SizedBox(height: 4.w),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Row(
            children: [
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<int>(
                      value: selectedName,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: [
                        DropdownMenuItem(
                          value: 0,
                          child: Text('Cash customer'.tr),
                        ),
                        DropdownMenuItem(
                          value: 1,
                          child: Text('Hassan modi'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedName = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    ));
  }
}
