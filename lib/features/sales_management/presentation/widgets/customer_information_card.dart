import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/customer_managment/data/models/customer_model.dart';
import 'package:teriak/features/customer_managment/presentation/controllers/customer_controller.dart';

class CustomerInformationCard extends StatelessWidget {
  final RxList<CustomerModel> customers;
  final Rx<CustomerModel?> selectedCustomer;
  final RxBool isLoading;
  final CustomerController customerController;
  final VoidCallback? onRefresh;

  const CustomerInformationCard({
    super.key,
    required this.customers,
    required this.selectedCustomer,
    required this.isLoading,
    required this.customerController,
    this.onRefresh,
  });

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
            const Spacer(),
            if (onRefresh != null)
              IconButton(
                onPressed: onRefresh,
                icon: Icon(
                  Icons.refresh,
                  size: 20,
                ),
                tooltip: 'Refresh Customers'.tr,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => isLoading.value == true
                          ? Center(
                              child: SizedBox(
                                height: 3.h,
                                width: 3.h,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : Row(
                              children: [
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: DropdownButton<CustomerModel>(
                                    hint: Text("Select Indebted Customer".tr),
                                    value: customers
                                            .contains(selectedCustomer.value)
                                        ? selectedCustomer.value
                                        : null,
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    items: customers.map((customer) {
                                      return DropdownMenuItem<CustomerModel>(
                                        value: customer,
                                        child: Text(customer.name),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        selectedCustomer.value = value;
                                        print(
                                            "✅ Selected customer ID: ${value.id}");
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
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
