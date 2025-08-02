import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/config/widgets/custom_app_bar.dart';
import 'package:teriak/features/indebted_management/presentation/widgets/customer_form_section.dart';
import 'package:teriak/features/indebted_management/presentation/widgets/debt_details_section.dart';
import 'package:teriak/features/indebted_management/presentation/widgets/payment_plan_section.dart';
import 'package:teriak/features/indebted_management/presentation/widgets/photo_capture_widget.dart';

class AddNewIndebtedCustomer extends StatefulWidget {
  const AddNewIndebtedCustomer({super.key});

  @override
  State<AddNewIndebtedCustomer> createState() => _AddNewIndebtedCustomerState();
}

class _AddNewIndebtedCustomerState extends State<AddNewIndebtedCustomer> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _debtAmountController = TextEditingController();
  final _notesController = TextEditingController();

  // Form state
  int _currentStep = 0;
  bool _isSubmitting = false;
  String? _profileImagePath;
  DateTime _dueDate = DateTime.now().add(Duration(days: 30));
  String _paymentTerms = '30 days';
  bool _enablePaymentPlan = false;
  int _installments = 1;
  double _installmentAmount = 0.0;

  final List<String> _paymentTermsOptions = [
    '30 days',
    '60 days',
    '90 days',
    'Custom',
  ];

  final List<String> _stepTitles = [
    'Customer Info',
    'Debt Details',
    'Payment Plan',
    'Review',
  ];

  Map<String, dynamic>? _existingCustomer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        _existingCustomer = args;
        _populateExistingData();
      }
    });
  }

  void _populateExistingData() {
    if (_existingCustomer != null) {
      _nameController.text = _existingCustomer!['name']?.toString() ?? '';
      _phoneController.text = _existingCustomer!['phone']?.toString() ?? '';
      _emailController.text = _existingCustomer!['email']?.toString() ?? '';
      _addressController.text = _existingCustomer!['address']?.toString() ?? '';
      _debtAmountController.text =
          (_existingCustomer!['totalDebt'] as num?)?.toStringAsFixed(2) ?? '';
      _notesController.text = _existingCustomer!['notes']?.toString() ?? '';
      _paymentTerms =
          _existingCustomer!['paymentTerms']?.toString() ?? '30 days';

      final dueDateStr = _existingCustomer!['dueDate']?.toString();
      if (dueDateStr != null) {
        _dueDate = DateTime.tryParse(dueDateStr) ??
            DateTime.now().add(Duration(days: 30));
      }

      setState(() {});
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _debtAmountController.dispose();
    _notesController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditing = _existingCustomer != null;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: isEditing ? 'Edit Customer' : 'Add New Indebted Customer',
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        actions: [
          if (_currentStep > 0)
            TextButton(
              onPressed: _previousStep,
              child: Text(
                'Back',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildProgressIndicator(theme, colorScheme),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildCustomerInfoStep(theme, colorScheme),
                _buildDebtDetailsStep(theme, colorScheme),
                _buildPaymentPlanStep(theme, colorScheme),
                _buildReviewStep(theme, colorScheme),
              ],
            ),
          ),
          _buildNavigationBar(theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(_stepTitles.length, (index) {
              final isActive = index == _currentStep;
              final isCompleted = index < _currentStep;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: isCompleted || isActive
                              ? colorScheme.primary
                              : colorScheme.outline.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    if (index < _stepTitles.length - 1) SizedBox(width: 2.w),
                  ],
                ),
              );
            }),
          ),
          SizedBox(height: 2.h),
          Text(
            'Step ${_currentStep + 1} of ${_stepTitles.length}: ${_stepTitles[_currentStep]}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoStep(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Information',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Enter the basic customer details to create their profile.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 3.h),
            PhotoCaptureWidget(
              initialImagePath: _profileImagePath,
              onImageCaptured: (imagePath) {
                setState(() {
                  _profileImagePath = imagePath;
                });
              },
            ),
            SizedBox(height: 3.h),
            CustomerFormSection(
              nameController: _nameController,
              phoneController: _phoneController,
              emailController: _emailController,
              addressController: _addressController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebtDetailsStep(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Debt Details',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Specify the debt amount and payment terms for this customer.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 3.h),
          DebtDetailsSection(
            debtAmountController: _debtAmountController,
            dueDate: _dueDate,
            paymentTerms: _paymentTerms,
            paymentTermsOptions: _paymentTermsOptions,
            notesController: _notesController,
            onDueDateChanged: (date) {
              setState(() {
                _dueDate = date;
              });
            },
            onPaymentTermsChanged: (terms) {
              setState(() {
                _paymentTerms = terms;
                // Auto-calculate due date based on terms
                if (terms == '30 days') {
                  _dueDate = DateTime.now().add(Duration(days: 30));
                } else if (terms == '60 days') {
                  _dueDate = DateTime.now().add(Duration(days: 60));
                } else if (terms == '90 days') {
                  _dueDate = DateTime.now().add(Duration(days: 90));
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentPlanStep(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Plan',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Set up flexible payment options for the customer.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 3.h),
          PaymentPlanSection(
            enablePaymentPlan: _enablePaymentPlan,
            installments: _installments,
            installmentAmount: _installmentAmount,
            totalDebt: double.tryParse(_debtAmountController.text) ?? 0.0,
            onEnablePaymentPlanChanged: (enabled) {
              setState(() {
                _enablePaymentPlan = enabled;
                if (enabled) {
                  final totalDebt =
                      double.tryParse(_debtAmountController.text) ?? 0.0;
                  _installmentAmount = totalDebt / _installments;
                }
              });
            },
            onInstallmentsChanged: (installments) {
              setState(() {
                _installments = installments;
                final totalDebt =
                    double.tryParse(_debtAmountController.text) ?? 0.0;
                _installmentAmount = totalDebt / _installments;
              });
            },
            paymentPlan: null,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review & Confirm',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Review all information before saving the customer record.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 3.h),
          _buildReviewSection(
            theme,
            colorScheme,
            'Customer Information',
            [
              _buildReviewItem('Name', _nameController.text),
              _buildReviewItem('Phone', _phoneController.text),
              _buildReviewItem('Email', _emailController.text),
              _buildReviewItem('Address', _addressController.text),
            ],
          ),
          SizedBox(height: 3.h),
          _buildReviewSection(
            theme,
            colorScheme,
            'Debt Information',
            [
              _buildReviewItem('Debt Amount',
                  '\$${(double.tryParse(_debtAmountController.text) ?? 0.0).toStringAsFixed(2)}'),
              _buildReviewItem('Due Date',
                  '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}'),
              _buildReviewItem('Payment Terms', _paymentTerms),
              if (_notesController.text.isNotEmpty)
                _buildReviewItem('Notes', _notesController.text),
            ],
          ),
          if (_enablePaymentPlan) ...[
            SizedBox(height: 3.h),
            _buildReviewSection(
              theme,
              colorScheme,
              'Payment Plan',
              [
                _buildReviewItem('Installments', '$_installments payments'),
                _buildReviewItem('Amount per Installment',
                    '\$${_installmentAmount.toStringAsFixed(2)}'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewSection(
    ThemeData theme,
    ColorScheme colorScheme,
    String title,
    List<Widget> children,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Divider(
            color: colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? 'Not provided' : value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                child: Text('Previous'),
              ),
            ),
          if (_currentStep > 0) SizedBox(width: 4.w),
          Expanded(
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _nextStep,
              child: _isSubmitting
                  ? SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(_currentStep == _stepTitles.length - 1
                      ? (_existingCustomer != null
                          ? 'Update Customer'
                          : 'Save Customer')
                      : 'Next'),
            ),
          ),
        ],
      ),
    );
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextStep() {
    if (_currentStep < _stepTitles.length - 1) {
      if (_validateCurrentStep()) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      _submitCustomer();
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _formKey.currentState?.validate() ?? false;
      case 1:
        if (_debtAmountController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please enter debt amount".tr),
              duration: Duration(seconds: 2),
            ),
          );

          return false;
        }
        final amount = double.tryParse(_debtAmountController.text);
        if (amount == null || amount <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please enter a valid debt amount".tr),
              duration: Duration(seconds: 2),
            ),
          );

          return false;
        }
        return true;
      case 2:
        return true; // Payment plan is optional
      case 3:
        return true; // Review step
      default:
        return true;
    }
  }

  Future<void> _submitCustomer() async {
    setState(() {
      _isSubmitting = true;
    });

    HapticFeedback.lightImpact();

    // Simulate API call
    await Future.delayed(Duration(milliseconds: 2000));

    final isEditing = _existingCustomer != null;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: isEditing
            ? Text('Customer updated successfully'.tr)
            : Text('Customer added successfully'),
        duration: Duration(seconds: 2),
      ),
    );

    setState(() {
      _isSubmitting = false;
    });

    Navigator.pop(context);
  }
}
