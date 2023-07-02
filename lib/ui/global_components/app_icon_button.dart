import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/app_loader/app_loader.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final double radius;
  final bool disabled;
  final double? iconSize;
  final Color? iconColor;
  final Color? background;
  final VoidCallback? onTap;

  const AppIconButton({
    super.key,
    this.onTap,
    this.iconSize,
    this.iconColor,
    this.background,
    this.radius = 23,
    required this.icon,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, _) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.secondary.withOpacity(0.5),
          borderRadius: BorderRadius.circular(100),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: background ?? theme.cardBackground,
            child: disabled
                ? const AppLoader(size: 20)
                : Icon(icon, color: iconColor ?? theme.heading, size: iconSize),
          ),
        ),
      );
    });
  }
}
