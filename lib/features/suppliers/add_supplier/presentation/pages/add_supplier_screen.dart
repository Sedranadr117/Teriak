import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

import './widgets/supplier_form_widget.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _selectedCurrency = 'USD';
  bool _isFormValid = false;
  bool _hasUnsavedChanges = false;
  bool _isSaving = false;

  // Mock existing suppliers for duplicate check
  final List<String> _existingSuppliers = [
    'ABC Trading Company',
    'Global Supplies Ltd',
    'Metro Distribution',
    'Prime Vendors Inc',
    'Elite Business Solutions',
  ];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
    _addressController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    final hasContent = _nameController.text.trim().isNotEmpty ||
        _phoneController.text.trim().isNotEmpty ||
        _addressController.text.trim().isNotEmpty;

    final isValid = _formKey.currentState?.validate() ?? false;

    setState(() {
      _hasUnsavedChanges = hasContent;
      _isFormValid = isValid &&
          _nameController.text.trim().isNotEmpty &&
          _phoneController.text.trim().isNotEmpty &&
          _addressController.text.trim().isNotEmpty;
    });
  }

  void _onCurrencyChanged(String currency) {
    setState(() {
      _selectedCurrency = currency;
      _hasUnsavedChanges = true;
    });
  }

  Future<bool> _checkDuplicateSupplier(String name) async {
    // Simulate network delay for duplicate check
    await Future.delayed(const Duration(milliseconds: 500));

    return _existingSuppliers.any(
      (supplier) => supplier.toLowerCase() == name.toLowerCase().trim(),
    );
  }

  void _showDuplicateDialog(String supplierName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: Theme.of(context).colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Duplicate Supplier'),
          ],
        ),
        content: Text(
          'A supplier with the name "$supplierName" already exists. Please use a different name or check if this is the same supplier.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSaveErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: Theme.of(context).colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Save Failed'),
          ],
        ),
        content: Text(
          'Unable to save supplier information. Please check your connection and try again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _saveSupplier();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveSupplier() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // Check for duplicate supplier
      final isDuplicate =
          await _checkDuplicateSupplier(_nameController.text.trim());

      if (isDuplicate) {
        setState(() => _isSaving = false);
        _showDuplicateDialog(_nameController.text.trim());
        return;
      }

      // Simulate save operation
      await Future.delayed(const Duration(milliseconds: 1500));

      // Simulate potential network error (10% chance)
      if (DateTime.now().millisecond % 10 == 0) {
        throw Exception('Network error');
      }

      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      // Show success toast
      Fluttertoast.showToast(
        msg: 'Supplier "${_nameController.text.trim()}" added successfully!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.primary,
        textColor: Theme.of(context).colorScheme.onPrimary,
        fontSize: 14.sp,
      );

      // Navigate back to supplier list
      Navigator.pushReplacementNamed(context, '/supplier-list-screen');
    } catch (e) {
      setState(() => _isSaving = false);
      _showSaveErrorDialog();
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Discard Changes?'),
        content: Text(
          'You have unsaved changes. Are you sure you want to leave without saving?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text('Discard'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Add Supplier',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          leading: IconButton(
            icon: CustomIconWidget(
              iconName: 'arrow_back_ios',
              color: Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            if (_hasUnsavedChanges)
              TextButton(
                onPressed: _isFormValid && !_isSaving ? _saveSupplier : null,
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: _isFormValid && !_isSaving
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            SizedBox(width: 2.w),
          ],
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 1,
          shadowColor: Theme.of(context).shadowColor.withValues(alpha: 0.1),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'add_business',
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 24,
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'New Supplier',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                'Fill in the details below to add a new supplier to your system',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Form Section
                  SupplierFormWidget(
                    formKey: _formKey,
                    nameController: _nameController,
                    phoneController: _phoneController,
                    addressController: _addressController,
                    selectedCurrency: _selectedCurrency,
                    onCurrencyChanged: _onCurrencyChanged,
                    onSave: _saveSupplier,
                    isFormValid: _isFormValid && !_isSaving,
                  ),

                  SizedBox(height: 2.h),

                  // Help Text
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomIconWidget(
                          iconName: 'info',
                          color: Theme.of(context).colorScheme.primary,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'All fields marked with * are required. Make sure to double-check the information before saving.',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.h), // Extra space for keyboard
                ],
              ),
            ),

            // Loading Overlay
            if (_isSaving)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Saving supplier...',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
