import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:flutter/material.dart';

class AppRadioButton extends StatelessWidget {
  final bool active;
  const AppRadioButton({super.key, this.active = false});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            width: isDark ? 1 : 2,
            color: isDark ? AppColors.secondary : AppColors.primary,
          ),
        ),
        child: CircleAvatar(
          backgroundColor: active
              ? isDark
                  ? AppColors.secondary
                  : AppColors.primary
              : Colors.transparent,
          radius: 6,
        ),
      );
    });
  }
}
