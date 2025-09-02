import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SimpleLoadingWidget extends StatefulWidget {
  final String? message;
  final double size;
  final Color? color;

  const SimpleLoadingWidget({
    super.key,
    this.message,
    this.size = 40,
    this.color,
  });

  @override
  State<SimpleLoadingWidget> createState() => _SimpleLoadingWidgetState();
}

class _SimpleLoadingWidgetState extends State<SimpleLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _animation.value * 2 * 3.14159,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(widget.size / 2),
                  border: Border.all(
                    color: color,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.local_pharmacy,
                    size: widget.size * 0.4,
                    color: color,
                  ),
                ),
              ),
            );
          },
        ),
        if (widget.message != null) ...[
          SizedBox(height: 2.h),
          Text(
            widget.message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
