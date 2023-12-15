import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/app_loader/app_loader.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

enum IconPosition { before, after }

class AppTextButton extends StatelessWidget {
  final String text;
  final Color? color;
  final bool disabled;
  final IconData? icon;
  final double textSize;
  final VoidCallback? onTap;
  final double paddingSpace;
  final FontWeight textWeight;
  final bool enableBackground;
  final Color? explicitBackground;
  final IconPosition iconPosition;

  const AppTextButton({
    super.key,
    this.icon,
    this.onTap,
    this.color,
    this.textSize = 15,
    required this.text,
    this.disabled = false,
    this.paddingSpace = 10,
    this.explicitBackground,
    this.enableBackground = false,
    this.textWeight = FontWeight.w600,
    this.iconPosition = IconPosition.before,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (theme, isDark) {
        bool showIcon = !disabled && icon != null;

        final Color finalColor =
            color ?? (isDark ? AppColors.secondary : AppColors.primary);
        final Widget iconWidget = Icon(
          icon,
          size: 20,
          color: disabled ? Colors.grey : finalColor,
        );
        bool iconAfter = showIcon && iconPosition == IconPosition.after;
        bool iconBefore = showIcon && iconPosition == IconPosition.before;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: disabled ? null : onTap,
            borderRadius: SmoothBorderRadius(cornerRadius: 20),
            child: Container(
              decoration: BoxDecoration(
                color: explicitBackground ??
                    (enableBackground
                        ? finalColor.withOpacity(0.05)
                        : Colors.transparent),
                borderRadius: SmoothBorderRadius(cornerRadius: 20),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: (paddingSpace / 2), horizontal: paddingSpace),
                child: Wrap(
                  spacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (iconBefore) iconWidget,
                    Wrap(
                      spacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (disabled) const AppLoader(size: 10),
                        Text(
                          disabled ? "Loading" : text,
                          style: TextStyle(
                            fontSize: textSize,
                            fontWeight: textWeight,
                            color: disabled ? Colors.grey : finalColor,
                          ),
                        ),
                      ],
                    ),
                    if (iconAfter) iconWidget,
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
