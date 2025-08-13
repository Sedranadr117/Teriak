import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/config/widgets/custom_app_bar.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/features/customer_managment/presentation/controllers/customer_controller.dart';
import 'package:teriak/features/customer_managment/presentation/widgets/customer_form_section.dart';

class AddNewIndebtedCustomer extends StatefulWidget {
  const AddNewIndebtedCustomer({super.key});

  @override
  State<AddNewIndebtedCustomer> createState() => _AddNewIndebtedCustomerState();
}

class _AddNewIndebtedCustomerState extends State<AddNewIndebtedCustomer> {
  CustomerController customerController = Get.put(CustomerController());

  // ignore: unused_field
  DateTime _dueDate = DateTime.now().add(Duration(days: 30));
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      customerController.isEditing = true;
      customerController.lastSelectedCustomerId = args['id'];
      customerController.nameController.text = args['name'] ?? '';
      customerController.phoneController.text = args['phoneNumber'] ?? '';
      customerController.addressController.text = args['address'] ?? '';
      customerController.notesController.text = args['notes'] ?? '';
      customerController.debtAmountController.text =
          (args['totalDebt']?.toString() ?? '');

      if (args['dueDate'] != null) {
        setState(() {
          _dueDate = DateTime.tryParse(args['dueDate']) ?? DateTime.now();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: CustomAppBar(
          title: customerController.isEditing
              ? 'Edit Customer'.tr
              : 'Add New Indebted Customer'.tr,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ),
        body: Column(children: [
          Expanded(
              child: SingleChildScrollView(
                  padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 5.h),
                  child: Form(
                    key: customerController.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer Information'.tr,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Enter the basic customer details to create their profile.'
                              .tr,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        CustomerFormSection(
                          nameController: customerController.nameController,
                          phoneController: customerController.phoneController,
                          notesController: customerController.notesController,
                          addressController:
                              customerController.addressController,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(
                                () => ElevatedButton(
                                  onPressed: customerController.isLoading.value
                                      ? null
                                      : () {
                                          final param = CustomerParams(
                                              notes: customerController
                                                  .notesController.text,
                                              name: customerController
                                                  .nameController.text,
                                              phoneNumber: customerController
                                                  .phoneController.text,
                                              address: customerController
                                                  .addressController.text);
                                          customerController.isEditing
                                              ? WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                  customerController.editCustomer(
                                                      customerController
                                                          .lastSelectedCustomerId!,
                                                      param);
                                                })
                                              : WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                  customerController
                                                      .createCustomer();
                                                });
                                        },
                                  child: customerController.isLoading.value
                                      ? SizedBox(
                                          width: 5.w,
                                          height: 5.w,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              colorScheme.onPrimary,
                                            ),
                                          ),
                                        )
                                      : Text(customerController.isEditing
                                          ? 'Update Customer'.tr
                                          : 'Add Customer'.tr),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )))
        ]));
  }
}
