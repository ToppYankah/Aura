import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/resources/app_svgs.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

class AppSlideButton extends StatefulWidget {
  final bool disabled;
  final String? submitText;
  final double buttonRadius;
  final IconData buttonIcon;
  final VoidCallback onSubmit;

  const AppSlideButton({
    super.key,
    this.buttonRadius = 30,
    required this.disabled,
    required this.onSubmit,
    this.submitText = "submit",
    this.buttonIcon = EvaIcons.checkmark,
  });

  @override
  State<AppSlideButton> createState() => _AppSlideButtonState();
}

class _AppSlideButtonState extends State<AppSlideButton>
    with SingleTickerProviderStateMixin {
  double _dx = 0;
  final GlobalKey _sliderKey = GlobalKey();
  late final AnimationController _controller;
  final ValueNotifier<double> _sliderWidth = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: 1,
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    CommonUtils.performPostBuild(context, getSliderWidth);
  }

  void getSliderWidth() {
    final RenderBox renderBox =
        _sliderKey.currentContext!.findRenderObject() as RenderBox;

    if (mounted) _sliderWidth.value = renderBox.size.width;
  }

  void _handleDragStart(DragStartDetails details) {
    if (widget.disabled) return;
    setState(() {
      _dx = details.localPosition.dx - widget.buttonRadius;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (widget.disabled) return;

    final double position = details.localPosition.dx - widget.buttonRadius;

    setState(() {
      if (position > 0 &&
          position < _sliderWidth.value - 10 - (widget.buttonRadius * 2)) {
        _dx = position;
      }
    });
  }

  void _handleDragEnd(DragEndDetails _) {
    if (widget.disabled) return;
    final int totalDistance =
        (_sliderWidth.value - (widget.buttonRadius / 2)).floor();
    final int displacement = (_dx + (widget.buttonRadius * 2)).floor();

    if (displacement >= totalDistance) widget.onSubmit();

    _controller.animateBack(0, curve: Curves.easeOutExpo).then((value) {
      _controller.value = 1;
      _dx = 0;
    });
  }

  @override
  void dispose() {
    _sliderWidth.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      final Color color = widget.disabled ? Colors.grey : AppColors.primary;
      final Color background =
          isDark ? Colors.white10 : AppColors.primary.withOpacity(0.2);

      return KeyboardVisibilityBuilder(
        builder: (context, isVisible) {
          return isVisible
              ? const SizedBox()
              : ClipSmoothRect(
                  radius: SmoothBorderRadius(cornerRadius: 50),
                  child: GestureDetector(
                    onHorizontalDragEnd: _handleDragEnd,
                    onHorizontalDragStart: _handleDragStart,
                    onHorizontalDragUpdate: _handleDragUpdate,
                    child: Container(
                      key: _sliderKey,
                      color: widget.disabled
                          ? Colors.grey.withOpacity(0.2)
                          : background,
                      padding: const EdgeInsets.all(5),
                      constraints:
                          BoxConstraints(minWidth: widget.buttonRadius * 7),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: widget.buttonRadius * 2.6),
                              alignment: Alignment.centerLeft,
                              child: Opacity(
                                opacity: widget.disabled ? 0.3 : 0.7,
                                child: Wrap(
                                  spacing: 10,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      "Slide to ${widget.submitText}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 26,
                                      child: SvgPicture.asset(AppSvgs.arrows),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(_dx * _controller.value, 0),
                                  child: CircleAvatar(
                                    radius: widget.buttonRadius,
                                    backgroundColor: color,
                                    child: Icon(
                                      widget.disabled
                                          ? Iconsax.lock_slash
                                          : widget.buttonIcon,
                                      size: widget.buttonRadius,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          // Positioned(
                          //   right: 0,
                          //   child: CircleAvatar(
                          //     radius: widget.buttonRadius,
                          //     backgroundColor: color.withOpacity(0.2),
                          //     child: const Icon(EvaIcons.checkmark,
                          //         size: 40, color: Colors.white24),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      );
    });
  }
}
