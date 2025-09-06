import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/pharmacy/presentation/controllers/add_pharmacy_controller.dart';
import '../widgets/location_input_widget.dart';
import '../widgets/pharmacy_form_section_widget.dart';
import '../widgets/progress_indicator_widget.dart';

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
  String _passwordStrength = '';
  Color _strengthColor = Colors.grey;

  @override
  void dispose() {
    _scrollController.dispose();
    addPharmacyController.passwordController
        .removeListener(_checkPasswordStrength);

    super.dispose();
  }

  void initState() {
    super.initState();
    addPharmacyController.passwordController
        .addListener(_checkPasswordStrength);
  }

  void _checkPasswordStrength() {
    final password = addPharmacyController.passwordController.text;

    if (password.isEmpty) {
      setState(() {
        _passwordStrength = '';
        _strengthColor = Colors.grey;
      });
      return;
    }

    int score = 0;

    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    setState(() {
      if (score <= 2) {
        _passwordStrength = 'Weak';
        _strengthColor = AppColors.errorLight;
      } else if (score <= 4) {
        _passwordStrength = 'Medium';
        _strengthColor = AppColors.warningLight;
      } else {
        _passwordStrength = 'Strong';
        _strengthColor = AppColors.successLight;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => addPharmacyController.onWillPop(context),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Complete Pharmacy Registration'.tr),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(10.h),
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
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
                      PharmacyFormSectionWidget(
                        title: 'Select Area'.tr,
                        isExpanded: true,
                        children: [
                          Obx(() => InkWell(
                                onTap: () async {
                                  addPharmacyController
                                          .isAreaDropdownOpen.value =
                                      !addPharmacyController
                                          .isAreaDropdownOpen.value;
                                  if (addPharmacyController
                                      .isAreaDropdownOpen.value) {
                                    FocusScope.of(context)
                                        .unfocus(); // يغلق الكيبورد
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        addPharmacyController
                                                    .selectedArea.value ==
                                                null
                                            ? 'Select Area'.tr
                                            : (addPharmacyController
                                                        .languageCode ==
                                                    "en"
                                                ? addPharmacyController
                                                    .selectedArea.value!.name
                                                : addPharmacyController
                                                    .selectedArea
                                                    .value!
                                                    .localizedName),
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: addPharmacyController
                                                      .selectedArea.value !=
                                                  null
                                              ? Colors.black
                                              : Colors.grey,
                                        ),
                                      ),
                                      Icon(addPharmacyController
                                              .isAreaDropdownOpen.value
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down),
                                    ],
                                  ),
                                ),
                              )),
                          Obx(() => addPharmacyController
                                  .isAreaDropdownOpen.value
                              ? Container(
                                  margin: EdgeInsets.only(top: 1.h),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: SizedBox(
                                    height: 205,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          addPharmacyController.areas.length,
                                      itemBuilder: (context, index) {
                                        final area =
                                            addPharmacyController.areas[index];
                                        return ListTile(
                                          dense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 0),
                                          minVerticalPadding: 0,
                                          visualDensity:
                                              VisualDensity(vertical: -2),
                                          title: addPharmacyController
                                                      .languageCode ==
                                                  "en"
                                              ? Text(area.name)
                                              : Text(area.localizedName),
                                          onTap: () {
                                            addPharmacyController
                                                .selectedArea.value = area;
                                            addPharmacyController
                                                .isAreaDropdownOpen
                                                .value = false;
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : SizedBox.shrink()),
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
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
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
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
                            Obx(() => Column(
                                  children: [
                                    TextFormField(
                                      controller: addPharmacyController
                                          .passwordController,
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
                                        suffixIcon: (addPharmacyController
                                                    .isPasswordValid.value &&
                                                _passwordStrength ==
                                                    'Strong'.tr)
                                            ? CustomIconWidget(
                                                iconName: 'check_circle',
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                size: 20,
                                              )
                                            : IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    addPharmacyController
                                                            .isPasswordVisible
                                                            .value =
                                                        !addPharmacyController
                                                            .isPasswordVisible
                                                            .value;
                                                  });
                                                },
                                                icon: CustomIconWidget(
                                                  iconName:
                                                      addPharmacyController
                                                              .isPasswordVisible
                                                              .value
                                                          ? 'visibility_off'
                                                          : 'visibility',
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                  size: 20,
                                                ),
                                              ),
                                      ),
                                      obscureText: !addPharmacyController
                                          .isPasswordVisible.value,
                                      textInputAction: TextInputAction.done,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Password is required'.tr;
                                        }
                                        if (value.trim().length < 6) {
                                          return 'Password must be at least 6 characters'
                                              .tr
                                              .tr;
                                        }
                                        return null;
                                      },
                                    ),
                                    if (_passwordStrength.isNotEmpty) ...[
                                      SizedBox(height: 2.w),
                                      Row(
                                        children: [
                                          Text(
                                            'Password Strength: '.tr,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                          Text(
                                            _passwordStrength,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: _strengthColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 1.w),
                                      LinearProgressIndicator(
                                        value: _passwordStrength == 'Weak'.tr
                                            ? 0.33
                                            : _passwordStrength == 'Medium'.tr
                                                ? 0.66
                                                : 1.0,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .outline
                                            .withValues(alpha: 0.3),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                _strengthColor),
                                      ),
                                    ],
                                    SizedBox(height: 3.w),
                                    Container(
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Password Requirements:'.tr,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                          ),
                                          SizedBox(height: 1.w),
                                          buildRequirement(
                                              'At least 6 characters'.tr,
                                              addPharmacyController
                                                      .passwordController
                                                      .text
                                                      .length >=
                                                  6),
                                          buildRequirement(
                                              'Contains uppercase letter'.tr,
                                              addPharmacyController
                                                  .passwordController.text
                                                  .contains(RegExp(r'[A-Z]'))),
                                          buildRequirement(
                                              'Contains lowercase letter'.tr,
                                              addPharmacyController
                                                  .passwordController.text
                                                  .contains(RegExp(r'[a-z]'))),
                                          buildRequirement(
                                              'Contains number'.tr,
                                              addPharmacyController
                                                  .passwordController.text
                                                  .contains(RegExp(r'[0-9]'))),
                                        ],
                                      ),
                                    ),
                                  ],
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
                                !addPharmacyController.isLoading.value &&
                                _passwordStrength == 'Strong'.tr &&
                                addPharmacyController.selectedArea.value !=
                                    null)
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
                            : Text('Complete Registration'.tr),
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

  Widget buildRequirement(String text, bool isMet) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.w),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: isMet ? 'check_circle' : 'radio_button_unchecked',
            color: isMet
                ? AppColors.successLight
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isMet
                      ? AppColors.successLight
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
