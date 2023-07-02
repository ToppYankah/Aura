import 'dart:ui';

import 'package:aura/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CarouselRing extends StatelessWidget {
  final double size;
  final bool blurred;
  final bool showLoader;
  const CarouselRing({
    super.key,
    required this.size,
    this.blurred = false,
    this.showLoader = false,
  });

  @override
  Widget build(BuildContext context) {
    final double blurValue = (blurred || showLoader) ? 20 : 0;

    return Align(
      alignment: Alignment.topCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size),
              border: Border.all(
                width: 5,
                color: AppColors.primary,
              ),
            ),
            child: showLoader
                ? LoadingAnimationWidget.fallingDot(
                    color: Colors.white, size: 80)
                : null,
          ),
        ),
      ),
    );
  }
}
