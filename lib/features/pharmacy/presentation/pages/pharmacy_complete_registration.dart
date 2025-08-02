import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';
<<<<<<< HEAD
import 'package:teriak/features/pharmacy/presentation/controllers/add_pharmacy_controller.dart';
import '../widgets/location_input_widget.dart';
import '../widgets/pharmacy_form_section_widget.dart';
import '../widgets/progress_indicator_widget.dart';
=======
import 'package:teriak/config/themes/app_theme.dart';
import 'package:teriak/features/employee_management/presentation/pages/employee_management.dart';
import 'package:teriak/features/pharmacy/presentation/pages/controllers/add_pharmacy_controller.dart';
import 'widgets/location_input_widget.dart';
import 'widgets/pharmacy_form_section_widget.dart';
import 'widgets/progress_indicator_widget.dart';
>>>>>>> products

class PharmacyCompleteRegistration extends StatefulWidget {
  const PharmacyCompleteRegistration({super.key});

  @override
  State<PharmacyCompleteRegistration> createState() =>
      _PharmacyCompleteRegistrationState();
}

class _PharmacyCompleteRegistrationState
    extends State<PharmacyCompleteRegistration> {
  final AddPharmacyController addPharmacyController =
      Get.put(AddPharmacyController());
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => addPharmacyController.onWillPop(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Add Pharmacy'.tr),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(8.h),
            child: Obx(() => ProgressIndicatorWidget(
                  progress: addPharmacyController.getProgress(),
                  isDraftSaved: addPharmacyController.isDraftSaved.value,
                )),
          ),
        ),
        body: Form(
          key: addPharmacyController.formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Information Section
                      PharmacyFormSectionWidget(
                        title: 'Basic Information'.tr,
                        isExpanded: true,
                        children: [
                          Column(
                            children: [
                              Obx(() => TextFormField(
                                    controller: addPharmacyController
                                        .managerFirstNameController,
                                    focusNode: addPharmacyController
                                        .managerFirstNameFocus,
                                    decoration: InputDecoration(
                                      labelText: 'First Name'.tr,
                                      hintText: 'Enter manager first name'.tr,
                                      counterText:
                                          '${addPharmacyController.managerFirstNameController.text.length}/50',
                                      suffixIcon: addPharmacyController
                                              .isManagerFirstNameValid.value
                                          ? CustomIconWidget(
                                              iconName: 'check_circle',
<<<<<<< HEAD
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
=======
                                              color: AppTheme.lightTheme(context)
                                                  .colorScheme.secondary,
>>>>>>> products
                                              size: 20,
                                            )
                                          : null,
                                    ),
                                    maxLength: 50,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context).requestFocus(
                                          addPharmacyController
                                              .managerLastNameFocus);
                                    },
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'First name is required'.tr;
                                      }
                                      if (value.trim().length < 3) {
                                        return 'First name must be at least 3 characters'
                                            .tr;
                                      }
                                      return null;
                                    },
                                  )),
                              SizedBox(height: 3.h),
                              Obx(() => TextFormField(
                                    controller: addPharmacyController
                                        .managerLastNameController,
                                    focusNode: addPharmacyController
                                        .managerLastNameFocus,
                                    decoration: InputDecoration(
                                      labelText: 'Last Name'.tr,
                                      hintText: 'Enter manager last name'.tr,
                                      counterText:
                                          '${addPharmacyController.managerLastNameController.text.length}/50',
                                      suffixIcon: addPharmacyController
                                              .isManagerLastNameValid.value
                                          ? CustomIconWidget(
                                              iconName: 'check_circle',
<<<<<<< HEAD
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
=======
                                              color: AppTheme.lightTheme(context)
                                                  .colorScheme.secondary,
>>>>>>> products
                                              size: 20,
                                            )
                                          : null,
                                    ),
                                    maxLength: 50,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context).requestFocus(
                                          addPharmacyController.locationFocus);
                                    },
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Last name is required'.tr;
                                      }
                                      if (value.trim().length < 3) {
                                        return 'Last name must be at least 3 characters'
                                            .tr;
                                      }
                                      return null;
                                    },
                                  )),
                            ],
                          ),
                          SizedBox(height: 3.h),
                          Obx(() => LocationInputWidget(
                                controller:
                                    addPharmacyController.locationController,
                                focusNode: addPharmacyController.locationFocus,
                                isValid:
                                    addPharmacyController.isLocationValid.value,
                                onNext: () {
                                  FocusScope.of(context).requestFocus(
                                      addPharmacyController.phoneFocus);
                                },
                              )),
                        ],
                      ),

                      SizedBox(height: 3.h),

                      // Contact Details Section
                      PharmacyFormSectionWidget(
                        title: 'Contact Details'.tr,
                        isExpanded: true,
                        children: [
                          Obx(() => TextFormField(
                                controller:
                                    addPharmacyController.phoneController,
                                focusNode: addPharmacyController.phoneFocus,
                                decoration: InputDecoration(
                                  labelText: 'Phone Number'.tr,
                                  hintText: '09xxxxxxxx',
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(3.w),
                                    child: CustomIconWidget(
                                      iconName: 'phone',
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 20,
                                    ),
                                  ),
                                  suffixIcon:
                                      addPharmacyController.isPhoneValid.value
                                          ? CustomIconWidget(
                                              iconName: 'check_circle',
<<<<<<< HEAD
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
=======
                                              color: AppTheme.lightTheme(context)
                                                  .colorScheme.secondary,
>>>>>>> products
                                              size: 20,
                                            )
                                          : null,
                                ),
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Phone number is required'.tr;
                                  }
                                  if (value.trim().length < 10) {
                                    return 'Please enter a valid phone number'
                                        .tr;
                                  }
                                  return null;
                                },
                              )),
                        ],
                      ),
                      PharmacyFormSectionWidget(
                        title: 'Opening Hours'.tr,
                        isExpanded: true,
                        children: [
                          Obx(() => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () =>
                                          addPharmacyController.pickTime(
                                              isOpening: true,
                                              context: context),
                                      child: Text('From:'.tr +
                                          ' ${addPharmacyController.formatTime(addPharmacyController.openingTime.value)}'
                                              .tr),
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () async =>
                                          await addPharmacyController.pickTime(
                                              isOpening: false,
                                              context: context),
                                      child: Text('To:'.tr +
                                          ' ${addPharmacyController.formatTime(addPharmacyController.closingTime.value)}'
                                              .tr),
                                    ),
                                  ),
                                ],
                              )),
                          Obx(() => !addPharmacyController
                                      .isOpeningHoursValid.value &&
                                  (addPharmacyController.openingTime.value !=
                                          null ||
                                      addPharmacyController.closingTime.value !=
                                          null)
                              ? Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text(
                                    addPharmacyController.openingTime.value ==
                                                null ||
                                            addPharmacyController
                                                    .closingTime.value ==
                                                null
                                        ? 'Please select both opening and closing times'
                                            .tr
                                        : 'Closing time must be after opening time'
                                            .tr,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                )
                              : SizedBox.shrink()),
                        ],
                      ),
                      SizedBox(height: 3.h),

                      PharmacyFormSectionWidget(
                          title: 'Credential Management'.tr,
                          isExpanded: true,
                          children: [
                            Obx(() => TextFormField(
                                  controller:
                                      addPharmacyController.emailController,
                                  focusNode: addPharmacyController.emailFocus,
                                  decoration: InputDecoration(
                                    labelText: 'Pharmacy Email'.tr,
                                    hintText: 'Enter Pharmacy email'.tr,
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(3.w),
                                      child: CustomIconWidget(
                                        iconName: 'person',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 20,
                                      ),
                                    ),
                                    suffixIcon:
                                        addPharmacyController.isEmailValid.value
                                            ? CustomIconWidget(
                                                iconName: 'check_circle',
<<<<<<< HEAD
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
=======
                                                color: AppTheme.lightTheme(context)
                                                    .colorScheme.secondary,
>>>>>>> products
                                                size: 20,
                                              )
                                            : null,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(
                                        addPharmacyController.passwordFocus);
                                  },
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Email is required'.tr;
                                    }
                                    if (!RegExp(
                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value.trim())) {
                                      return 'Please enter a valid email'.tr;
                                    }
                                    return null;
                                  },
                                )),
                            SizedBox(height: 3.h),
                            Obx(() => TextFormField(
                                  controller:
                                      addPharmacyController.passwordController,
                                  focusNode:
                                      addPharmacyController.passwordFocus,
                                  decoration: InputDecoration(
                                    labelText: 'New Password'.tr,
                                    hintText: 'Enter a new password'.tr,
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(3.w),
                                      child: CustomIconWidget(
                                        iconName: 'lock',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 20,
                                      ),
                                    ),
                                    suffixIcon: addPharmacyController
                                            .isPasswordValid.value
                                        ? CustomIconWidget(
                                            iconName: 'check_circle',
<<<<<<< HEAD
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
=======
                                            color: AppTheme.lightTheme(context)
                                                .colorScheme.secondary,
>>>>>>> products
                                            size: 20,
                                          )
                                        : null,
                                  ),
                                  obscureText: !addPharmacyController
                                      .isPasswordVisible.value,
                                  textInputAction: TextInputAction.done,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Password is required'.tr;
                                    }
                                    if (value.trim().length < 6) {
                                      return 'Password must be at least 6 characters'
                                          .tr
                                          .tr;
                                    }
                                    return null;
                                  },
                                )),
                          ]),

                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: ElevatedButton(
                        onPressed: (addPharmacyController
                                    .isManagerFirstNameValid.value &&
                                addPharmacyController
                                    .isManagerLastNameValid.value &&
                                addPharmacyController.isLocationValid.value &&
                                addPharmacyController.isPhoneValid.value &&
                                addPharmacyController
                                    .isOpeningHoursValid.value &&
                                addPharmacyController.isEmailValid.value &&
                                addPharmacyController.isPasswordValid.value &&
                                !addPharmacyController.isLoading.value)
                            ? addPharmacyController.addPharmacy
                            : null,
                        child: addPharmacyController.isLoading.value
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : Text('Add Pharmacy'.tr),
                      ),
                    )),
                SizedBox(height: 2.h),
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: OutlinedButton(
                        onPressed: addPharmacyController.isLoading.value
                            ? null
                            : () async {
                                if (await addPharmacyController
                                    .onWillPop(context)) {
                                  Navigator.pop(context);
                                }
                              },
                        child: Text('Cancel'.tr),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
