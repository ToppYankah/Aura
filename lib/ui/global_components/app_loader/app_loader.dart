import 'package:flutter/material.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppLoader extends StatelessWidget {
  final double size;
  const AppLoader({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.discreteCircle(
      size: size,
      color: Colors.white,
      thirdRingColor: AppColors.primary,
      secondRingColor: AppColors.secondary,
    );
  }
}
