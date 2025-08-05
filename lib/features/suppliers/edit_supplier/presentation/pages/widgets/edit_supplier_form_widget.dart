import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class EditSupplierFormWidget extends StatefulWidget {
  final Map<String, dynamic> supplierData;
  final Function(Map<String, dynamic>) onSave;
  final VoidCallback onCancel;

  const EditSupplierFormWidget({
    super.key,
    required this.supplierData,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<EditSupplierFormWidget> createState() => _EditSupplierFormWidgetState();
}

class _EditSupplierFormWidgetState extends State<EditSupplierFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedCurrency = 'USD';
  bool _hasChanges = false;
  bool _isLoading = false;

  final List<String> _currencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'AUD',
    'CAD',
    'CHF',
    'CNY',
    'SEK',
    'NZD'
  ];

  Map<String, dynamic> _originalData = {};

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    _originalData = Map<String, dynamic>.from(widget.supplierData);
    _nameController.text = widget.supplierData['name'] ?? '';
    _phoneController.text = widget.supplierData['phone'] ?? '';
    _addressController.text = widget.supplierData['address'] ?? '';
    _selectedCurrency = widget.supplierData['preferredCurrency'] ?? 'USD';

    _nameController.addListener(_checkForChanges);
    _phoneController.addListener(_checkForChanges);
    _addressController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    final hasChanges = _nameController.text != _originalData['name'] ||
        _phoneController.text != _originalData['phone'] ||
        _addressController.text != _originalData['address'] ||
        _selectedCurrency != _originalData['preferredCurrency'];

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate save operation
    await Future.delayed(const Duration(milliseconds: 800));

    final updatedData = {
      ...widget.supplierData,
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'address': _addressController.text.trim(),
      'preferredCurrency': _selectedCurrency,
      'lastModified': DateTime.now().toIso8601String(),
    };

    setState(() {
      _isLoading = false;
    });

    widget.onSave(updatedData);
  }

  void _handleCancel() {
    if (_hasChanges) {
      _showUnsavedChangesDialog();
    } else {
      widget.onCancel();
    }
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Unsaved Changes',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'You have unsaved changes. Are you sure you want to discard them?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Editing'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onCancel();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Supplier Name Field
          Container(
            margin: EdgeInsets.only(bottom: 3.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Supplier Name',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter supplier name',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'business',
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _nameController.text != _originalData['name']
                            ? colorScheme.primary.withValues(alpha: 0.5)
                            : colorScheme.outline,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _nameController.text != _originalData['name']
                            ? colorScheme.primary.withValues(alpha: 0.5)
                            : colorScheme.outline,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Supplier name is required';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),
          ),

          // Phone Field
          Container(
            margin: EdgeInsets.only(bottom: 3.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phone Number',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'phone',
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _phoneController.text != _originalData['phone']
                            ? colorScheme.primary.withValues(alpha: 0.5)
                            : colorScheme.outline,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _phoneController.text != _originalData['phone']
                            ? colorScheme.primary.withValues(alpha: 0.5)
                            : colorScheme.outline,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number is required';
                    }
                    if (value.trim().length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),
          ),

          // Address Field
          Container(
            margin: EdgeInsets.only(bottom: 3.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Address',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Enter supplier address',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'location_on',
                        color: colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            _addressController.text != _originalData['address']
                                ? colorScheme.primary.withValues(alpha: 0.5)
                                : colorScheme.outline,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            _addressController.text != _originalData['address']
                                ? colorScheme.primary.withValues(alpha: 0.5)
                                : colorScheme.outline,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Address is required';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),

          // Currency Selection
          Container(
            margin: EdgeInsets.only(bottom: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Preferred Currency',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedCurrency !=
                              _originalData['preferredCurrency']
                          ? colorScheme.primary.withValues(alpha: 0.5)
                          : colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedCurrency,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'attach_money',
                          color: colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                    ),
                    items: _currencies.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCurrency = value;
                        });
                        _checkForChanges();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _handleCancel,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: (_hasChanges && !_isLoading) ? _handleSave : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: _hasChanges
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          'Update Supplier',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _hasChanges
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
