import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teriak/config/extensions/responsive.dart';
import 'package:teriak/config/themes/app_icon.dart';

// ignore: must_be_immutable
class SaveProductButton extends StatefulWidget {
  bool Function() isFormValid;
  void Function() onTap;
  String label;
  SaveProductButton(
      {super.key, required this.isFormValid, required this.onTap,required this.label});

  @override
  State<SaveProductButton> createState() => _SaveProductButtonState();
}

class _SaveProductButtonState extends State<SaveProductButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w * 0.04),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: widget.isFormValid() ? widget.onTap : () {},
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: context.h * 0.02),
            backgroundColor: widget.isFormValid()
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'save',
                color: Theme.of(context).colorScheme.onPrimary,
                size: 20,
              ),
              SizedBox(width: context.w * 0.02),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
