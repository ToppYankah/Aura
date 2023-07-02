import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:flutter/material.dart';

class TipTab extends StatefulWidget {
  final bool active;
  final bool skipped;
  final VoidCallback onComplete;

  const TipTab(
      {super.key,
      this.active = false,
      this.skipped = false,
      required this.onComplete});

  @override
  State<TipTab> createState() => _TipTabState();
}

class _TipTabState extends State<TipTab> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.addListener(() {
      if (_controller.isCompleted) widget.onComplete();
    });

    if (widget.active) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant TipTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active) {
      if (_controller.isCompleted) {
        _controller
          ..reset()
          ..forward();
      } else {
        _controller.forward();
      }
    } else if (widget.skipped) {
      _controller.forward(from: 1);
    } else {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(10);
    return ThemeBuilder(builder: (theme, isDark) {
      return Expanded(
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                color: isDark
                    ? AppColors.secondary.withOpacity(0.2)
                    : AppColors.primary.withOpacity(0.2),
                borderRadius: radius),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, _) {
                      return Container(
                        height: 5,
                        width: constraints.maxWidth * _animation.value,
                        decoration: BoxDecoration(
                          color:
                              isDark ? AppColors.secondary : AppColors.primary,
                          borderRadius: radius,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      );
    });
  }
}
