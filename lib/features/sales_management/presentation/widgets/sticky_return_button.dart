import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:teriak/config/themes/app_icon.dart';

class StickyReturnButton extends StatefulWidget {
  final int selectedItemsCount;
  final bool isEnabled;
  final VoidCallback? onPressed;

  const StickyReturnButton({
    super.key,
    required this.selectedItemsCount,
    this.isEnabled = false,
    this.onPressed,
  });

  @override
  State<StickyReturnButton> createState() => _StickyReturnButtonState();
}

class _StickyReturnButtonState extends State<StickyReturnButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    if (widget.selectedItemsCount > 0) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(StickyReturnButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedItemsCount > 0 && oldWidget.selectedItemsCount == 0) {
      _animationController.forward();
    } else if (widget.selectedItemsCount == 0 &&
        oldWidget.selectedItemsCount > 0) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.1),
                    offset: const Offset(0, -2),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Process Return Button
                    SizedBox(
                      width: double.infinity,
                      height: 6.h,
                      child: ElevatedButton(
                        onPressed: widget.isEnabled
                            ? () {
                                HapticFeedback.mediumImpact();
                                widget.onPressed?.call();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.isEnabled
                              ? colorScheme.primary
                              : theme.brightness == Brightness.light
                                  ? const Color(0xFF9E9E9E)
                                  : const Color(0xFF616161),
                          foregroundColor: widget.isEnabled
                              ? colorScheme.onPrimary
                              : theme.brightness == Brightness.light
                                  ? const Color(0x61212121)
                                  : const Color(0x61FFFFFF),
                          elevation: widget.isEnabled ? 4 : 0,
                          shadowColor:
                              colorScheme.primary.withValues(alpha: 0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'assignment_return',
                              color: widget.isEnabled
                                  ? colorScheme.onPrimary
                                  : theme.brightness == Brightness.light
                                      ? const Color(0x61212121)
                                      : const Color(0x61FFFFFF),
                              size: 6.w,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              widget.selectedItemsCount > 0
                                  ? '${'Process Return'.tr} (${widget.selectedItemsCount})'
                                  : 'Process Return'.tr,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                color: widget.isEnabled
                                    ? colorScheme.onPrimary
                                    : theme.brightness == Brightness.light
                                        ? const Color(0x61212121)
                                        : const Color(0x61FFFFFF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Helper text
                    if (!widget.isEnabled &&
                        widget.selectedItemsCount == 0) ...[
                      SizedBox(height: 1.h),
                      Text(
                        'Select items to enable return processing',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.brightness == Brightness.light
                              ? const Color(0x99212121)
                              : const Color(0x99FFFFFF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
