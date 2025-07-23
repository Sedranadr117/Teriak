import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/config/themes/app_colors.dart';

class AddShiftBottomSheetWidget extends StatefulWidget {
  final ShiftParams? existingShift;
  final void Function(ShiftParams shift, {int? existingId}) onShiftAdded;

  const AddShiftBottomSheetWidget({
    Key? key,
    this.existingShift,
    required this.onShiftAdded,
  }) : super(key: key);

  @override
  State<AddShiftBottomSheetWidget> createState() =>
      _AddShiftBottomSheetWidgetState();
}

class _AddShiftBottomSheetWidgetState extends State<AddShiftBottomSheetWidget> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  String? selectedDay;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingShift != null) {
      isEditing = true;
      _descriptionController.text = widget.existingShift!.description;

      // Parse existing times
      final startParts = widget.existingShift!.startTime.split(':');
      startTime = TimeOfDay(
        hour: int.parse(startParts[0]),
        minute: int.parse(startParts[1]),
      );

      final endParts = widget.existingShift!.endTime.split(':');
      endTime = TimeOfDay(
        hour: int.parse(endParts[0]),
        minute: int.parse(endParts[1]),
      );
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatTimeDisplay(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');

    if (hour == 0) {
      return '12:$minute AM';
    } else if (hour < 12) {
      return '$hour:$minute AM';
    } else if (hour == 12) {
      return '12:$minute PM';
    } else {
      return '${hour - 12}:$minute PM';
    }
  }

  bool _isValidTimeRange() {
    if (startTime == null || endTime == null) return false;

    final startMinutes = startTime!.hour * 60 + startTime!.minute;
    final endMinutes = endTime!.hour * 60 + endTime!.minute;

    // Allow overnight shifts
    return startMinutes != endMinutes;
  }

  bool _isOvernightShift() {
    if (startTime == null || endTime == null) return false;

    final startMinutes = startTime!.hour * 60 + startTime!.minute;
    final endMinutes = endTime!.hour * 60 + endTime!.minute;

    return endMinutes <= startMinutes;
  }

  void _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (startTime ?? TimeOfDay.now())
          : (endTime ?? TimeOfDay.now()),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              hourMinuteTextColor: Theme.of(context).colorScheme.primary,
              dialHandColor: Theme.of(context).colorScheme.primary,
              dialBackgroundColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  void _saveShift() {
    if (!_formKey.currentState!.validate()) return;
    if (startTime == null || endTime == null) return;
    if (!_isValidTimeRange()) return;

    final shiftData = ShiftParams(_formatTimeOfDay(startTime!),
        _formatTimeOfDay(endTime!), _descriptionController.text.trim());

    widget.onShiftAdded(shiftData);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      width: 12.w,
                      height: 0.5.h,
                      decoration: BoxDecoration(
                        color: AppColors.borderLight,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Header
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: isEditing ? 'edit' : 'add',
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        isEditing ? 'Edit Shift'.tr : 'Add New Shift'.tr,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Time Selection
                  Row(
                    children: [
                      // Start Time
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Time'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            SizedBox(height: 1.h),
                            GestureDetector(
                              onTap: () => _selectTime(context, true),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.borderLight),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'access_time',
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 20,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      startTime != null
                                          ? _formatTimeDisplay(startTime!)
                                          : 'Select time'.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: startTime != null
                                                ? AppColors.textPrimaryLight
                                                : AppColors.textSecondaryLight,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 4.w),

                      // End Time
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End Time'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            SizedBox(height: 1.h),
                            GestureDetector(
                              onTap: () => _selectTime(context, false),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.borderLight),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'access_time',
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 20,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      endTime != null
                                          ? _formatTimeDisplay(endTime!)
                                          : 'Select time'.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: endTime != null
                                                ? AppColors.textPrimaryLight
                                                : AppColors.textSecondaryLight,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Overnight Shift Indicator
                  if (startTime != null &&
                      endTime != null &&
                      _isOvernightShift()) ...[
                    SizedBox(height: 1.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'nights_stay',
                            color: Theme.of(context).colorScheme.secondary,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'This is an overnight shift',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  fontSize: 12.sp,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Time Validation Error
                  if (startTime != null &&
                      endTime != null &&
                      !_isValidTimeRange()) ...[
                    SizedBox(height: 1.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .error
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'error',
                            color: Theme.of(context).colorScheme.error,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Start and end times cannot be the same'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  fontSize: 12.sp,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: 3.h),

                  // Description
                  Text(
                    'Description (Optional)'.tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(height: 1.h),

                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter shift description...'.tr,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'description',
                          color: AppColors.textSecondaryLight,
                          size: 20,
                        ),
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  SizedBox(height: 4.h),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'.tr),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (startTime != null &&
                                  endTime != null &&
                                  _isValidTimeRange())
                              ? _saveShift
                              : null,
                          child: Text(
                              isEditing ? 'Update Shift'.tr : 'Add Shift'.tr),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
