import 'package:flutter/material.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/theme_builder.dart';

class SectionCardTitle extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;

  const SectionCardTitle(
    this.title, {
    this.icon,
    super.key,
    this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final finalIconColor = iconColor ?? AppColors.secondary.shade600;

    return ThemeBuilder(builder: (theme, isDark) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15)
            .copyWith(bottom: icon != null ? 5 : 5),
        child: Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (icon != null)
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: finalIconColor.withOpacity(0.15),
                      child: Icon(icon, size: 17, color: finalIconColor),
                    ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      color: theme.heading,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!
          ],
        ),
      );
    });
  }
}
