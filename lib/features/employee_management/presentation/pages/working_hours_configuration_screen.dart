import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_colors.dart';
import 'package:teriak/core/params/params.dart';
import 'package:teriak/config/themes/app_icon.dart';
import 'package:teriak/features/employee_management/presentation/controllers/employee_controller.dart';
import 'package:teriak/features/employee_management/presentation/widgets/dialogs.dart';

import '../widgets/add_shift_bottom_sheet_widget.dart';
import '../widgets/shift_card_widget.dart';

class WorkingHoursConfigurationScreen extends StatefulWidget {
  const WorkingHoursConfigurationScreen({super.key});

  @override
  State<WorkingHoursConfigurationScreen> createState() =>
      _WorkingHoursConfigurationScreenState();
}

class _WorkingHoursConfigurationScreenState
    extends State<WorkingHoursConfigurationScreen> {
  final controller = Get.find<EmployeeController>();
  Dialogs dialogs = Dialogs();

  final ScrollController _scrollController = ScrollController();
  List<WorkingHoursRequestParams> allWorkingHours = [];

  _showAddShiftBottomSheet({ShiftParams? existingShift, int? existingIndex}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddShiftBottomSheetWidget(
        existingShift: existingShift,
        daysOfWeek: controller.daysOfWeek,
        onShiftAdded: (shift, {selectedDays}) {
          controller.addShift(
            shift,
            selectedDays: selectedDays ?? [],
          );
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 2,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).colorScheme.onPrimary,
            size: 24,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Working Hours'.tr,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18.sp,
                  ),
            ),
          ],
        ),
        actions: [
          if (controller.hasShiftConflicts())
            Padding(
              padding: EdgeInsets.only(left: 4.w, right: 4.w),
              child: const CustomIconWidget(
                iconName: 'warning',
                color: AppColors.warningLight,
                size: 24,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Shifts Schedule'.tr,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      if (controller.shifts.isNotEmpty)
                        Obx(
                          () => Text(
                            '${controller.shifts.length} shift${controller.shifts.length > 1 ? 's' : ''}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 12.sp,
                                      color: AppColors.textSecondaryLight,
                                    ),
                          ),
                        ),
                      IconButton(
                        onPressed: () {
                          _showAddShiftBottomSheet();
                        },
                        icon: const CustomIconWidget(
                          iconName: 'add',
                          size: 25,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 1.h),
                  if (controller.hasShiftConflicts())
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(3.w),
                      margin: EdgeInsets.only(bottom: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.warningLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.warningLight.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const CustomIconWidget(
                            iconName: 'warning',
                            color: AppColors.warningLight,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              'Shift conflicts detected. Please review overlapping time slots.'
                                  .tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontSize: 12.sp,
                                    color: AppColors.warningLight,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Obx(() {
                    if (controller.shifts.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.borderLight.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Column(
                          children: [
                            const CustomIconWidget(
                              iconName: 'schedule',
                              color: AppColors.textSecondaryLight,
                              size: 48,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'No shifts scheduled'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontSize: 16.sp,
                                    color: AppColors.textSecondaryLight,
                                  ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Add your first shift to get started with scheduling'
                                  .tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondaryLight,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.shifts.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 1.h),
                        itemBuilder: (context, index) {
                          final shift = controller.shifts[index];
                          final shiftDays = controller.workingHoursRequests
                              .firstWhere(
                                (req) => req.shifts.contains(shift),
                              )
                              .daysOfWeek;
                          return ShiftCardWidget(
                            shift: shift,
                            hasConflict: controller.hasShiftConflicts(),
                            onEdit: () => _showAddShiftBottomSheet(
                              existingShift: shift,
                              existingIndex: index,
                            ),
                            onDelete: () => controller.deleteShift(shift),
                            daysOfWeek: shiftDays,
                          );
                        },
                      );
                    }
                  })
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          controller.saveWorkingHours();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Obx(
                    () => controller.isLoading.value
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
                        : Text(
                            (controller.employee.value?.workingHoursRequests
                                        .isNotEmpty ??
                                    false)
                                ? 'Edit Schedule'.tr
                                : 'Save Schedule'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
