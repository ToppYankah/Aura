import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final double? textSize;
  final Color? textColor;
  final Color? background;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const AppButton({
    super.key,
    this.onTap,
    this.margin,
    this.textColor,
    this.background,
    this.textSize = 16,
    this.text = "Tap Me!",
    this.padding = const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
  });

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      return Padding(
        padding: margin ?? EdgeInsets.zero,
        child: ClipSmoothRect(
          radius: SmoothBorderRadius(
            cornerRadius: 25,
            cornerSmoothing: 0.8,
          ),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: padding,
              color: background ?? theme.cardBackground,
              alignment: Alignment.center,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? theme.heading,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
