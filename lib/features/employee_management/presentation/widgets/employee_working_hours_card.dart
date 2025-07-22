import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/core/themes/app_theme.dart';
import 'package:teriak/core/widgets/custom_icon_widget.dart';

class EmployeeWorkingHoursCard extends StatelessWidget {
  final Map<String, dynamic> employee;
  final VoidCallback? onViewFullSchedule;

  const EmployeeWorkingHoursCard({
    Key? key,
    required this.employee,
    this.onViewFullSchedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic>? workingHoursRequests =
        employee['workingHours'] as List<dynamic>?;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Working Hours',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 4.w),

          if (workingHoursRequests != null &&
              workingHoursRequests.isNotEmpty) ...[
            ...workingHoursRequests
                .map((wh) => _buildWorkingHoursSection(wh, context))
                .toList(),
            SizedBox(height: 4.w),
          ] else ...[
            Center(
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 32,
                  ),
                  SizedBox(height: 2.w),
                  Text(
                    'No schedule configured',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.w),
          ],

          // View Full Schedule Button
          Center(
            child: OutlinedButton(
              onPressed: onViewFullSchedule,
              child: Text('View Full Schedule'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingHoursSection(
      Map<String, dynamic> wh, BuildContext context) {
    final List daysOfWeek = wh['daysOfWeek'] ?? [];
    final List shifts = wh['shifts'] ?? [];

    return Container(
      margin: EdgeInsets.only(bottom: 2.w),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withAlpha(77), // alpha: 0.3
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Days: ',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              Expanded(
                child: Text(
                  daysOfWeek.join(', '),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.w),
          ...shifts.map<Widget>((shift) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 1.w),
              child: Row(
                children: [
                  Icon(Icons.access_time,
                      size: 18, color: Theme.of(context).colorScheme.primary),
                  SizedBox(width: 2.w),
                  Text(
                    '${shift['startTime']} - ${shift['endTime']}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  if (shift['description'] != null &&
                      (shift['description'] as String).isNotEmpty) ...[
                    SizedBox(width: 2.w),
                    Text(
                      '(${shift['description']})',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ]
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
