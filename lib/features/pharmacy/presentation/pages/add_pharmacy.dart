import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/routes/app_pages.dart';
import 'package:teriak/core/custom_icon_widget.dart';
import 'package:teriak/core/themes/app_theme.dart';
import 'package:teriak/features/employee_management/employee_management.dart';
import './widgets/location_input_widget.dart';
import './widgets/pharmacy_form_section_widget.dart';
import './widgets/progress_indicator_widget.dart';

class AddPharmacy extends StatefulWidget {
  const AddPharmacy({super.key});

  @override
  State<AddPharmacy> createState() => _AddPharmacyState();
}

class _AddPharmacyState extends State<AddPharmacy> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // Form controllers
  final TextEditingController _pharmacyNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Form state
  bool _isLoading = false;
  bool _isDraftSaved = false;
  double _formProgress = 0.0;

  // Validation states
  bool _isPharmacyNameValid = false;
  bool _isLocationValid = false;
  bool _isPhoneValid = false;

  // Focus nodes
  final FocusNode _pharmacyNameFocus = FocusNode();
  final FocusNode _locationFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _setupFormListeners();
    _loadDraftData();
  }

  @override
  void dispose() {
    _pharmacyNameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _pharmacyNameFocus.dispose();
    _locationFocus.dispose();
    _phoneFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _setupFormListeners() {
    _pharmacyNameController.addListener(_updateFormProgress);
    _locationController.addListener(_updateFormProgress);
    _phoneController.addListener(_updateFormProgress);
  }

  void _updateFormProgress() {
    setState(() {
      _isPharmacyNameValid = _pharmacyNameController.text.trim().length >= 3;
      _isLocationValid = _locationController.text.trim().length >= 10;
      _isPhoneValid = _phoneController.text.trim().length >= 10;

      int validFields = 0;
      if (_isPharmacyNameValid) validFields++;
      if (_isLocationValid) validFields++;
      if (_isPhoneValid) validFields++;

      _formProgress = validFields / 3.0;
    });
  }

  void _loadDraftData() {
    // Mock loading draft data from local storage
    // In real implementation, use SharedPreferences or secure storage
  }

  Future<void> _saveDraft() async {
    setState(() {
      _isLoading = true;
    });

    // Mock saving draft data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _isDraftSaved = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Draft saved successfully'),
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        ),
      );
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Mock API call to create pharmacy
      await Future.delayed(const Duration(seconds: 2));

      // Haptic feedback for success
      HapticFeedback.lightImpact();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pharmacy added successfully!'),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          ),
        );

        // Navigate back or to pharmacy detail
        Get.offNamed(AppPages.employeeManagement);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add pharmacy. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (_pharmacyNameController.text.isNotEmpty ||
        _locationController.text.isNotEmpty ||
        _phoneController.text.isNotEmpty) {
      return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Discard Changes?'),
              content: Text(
                  'You have unsaved changes. Do you want to discard them?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Discard'),
                ),
              ],
            ),
          ) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Add Pharmacy'),
          leading: IconButton(
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const EmployeeManagement(),
                  ),
                );
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: _isLoading ? null : _saveDraft,
              child: Text('Save Draft'),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(8.h),
            child: ProgressIndicatorWidget(
              progress: _formProgress,
              isDraftSaved: _isDraftSaved,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
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
                        title: 'Basic Information',
                        isExpanded: true,
                        children: [
                          TextFormField(
                            controller: _pharmacyNameController,
                            focusNode: _pharmacyNameFocus,
                            decoration: InputDecoration(
                              labelText: 'Pharmacy Name *',
                              hintText: 'Enter pharmacy name',
                              counterText:
                                  '${_pharmacyNameController.text.length}/50',
                              suffixIcon: _isPharmacyNameValid
                                  ? CustomIconWidget(
                                      iconName: 'check_circle',
                                      color: AppTheme
                                          .lightTheme.colorScheme.secondary,
                                      size: 20,
                                    )
                                  : null,
                            ),
                            maxLength: 50,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_locationFocus);
                            },
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Pharmacy name is required';
                              }
                              if (value.trim().length < 3) {
                                return 'Pharmacy name must be at least 3 characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 3.h),
                          LocationInputWidget(
                            controller: _locationController,
                            focusNode: _locationFocus,
                            isValid: _isLocationValid,
                            onNext: () {
                              FocusScope.of(context).requestFocus(_phoneFocus);
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 3.h),

                      // Contact Details Section
                      PharmacyFormSectionWidget(
                        title: 'Contact Details',
                        isExpanded: true,
                        children: [
                          TextFormField(
                            controller: _phoneController,
                            focusNode: _phoneFocus,
                            decoration: InputDecoration(
                              labelText: 'Phone Number *',
                              hintText: '+1 (555) 123-4567',
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(3.w),
                                child: CustomIconWidget(
                                  iconName: 'phone',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                              suffixIcon: _isPhoneValid
                                  ? CustomIconWidget(
                                      iconName: 'check_circle',
                                      color: AppTheme
                                          .lightTheme.colorScheme.secondary,
                                      size: 20,
                                    )
                                  : null,
                            ),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Phone number is required';
                              }
                              if (value.trim().length < 10) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

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
            color: AppTheme.lightTheme.colorScheme.surface,
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
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: (_isPharmacyNameValid &&
                            _isLocationValid &&
                            _isPhoneValid &&
                            !_isLoading)
                        ? _submitForm
                        : null,
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text('Add Pharmacy'),
                  ),
                ),
                SizedBox(height: 2.h),
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: OutlinedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (await _onWillPop()) {
                              Navigator.pop(context);
                            }
                          },
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
