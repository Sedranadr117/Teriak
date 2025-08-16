import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_icon.dart';

// ignore: must_be_immutable
class SwitchCard extends StatefulWidget {
  void Function(bool)? onChanged;
  bool value;
  SwitchCard({super.key, required this.onChanged, required this.value});

  @override
  State<SwitchCard> createState() => _SwitchCardState();
}

class _SwitchCardState extends State<SwitchCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w * 0.03),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'medical_services',
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20,
          ),
          SizedBox(width: context.w * 0.03),
          Expanded(
            child: Text(
              'Prescription Required'.tr,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          SizedBox(width: context.w * 0.02),
          Switch(
            value: widget.value,
            onChanged: widget.onChanged,
            activeColor: Theme.of(context).colorScheme.error,
          ),
        ],
      ),
    );
  }
}
