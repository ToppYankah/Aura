import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:flutter/material.dart';

class AppSwitchButton extends StatelessWidget {
  final bool isOn;
  const AppSwitchButton({super.key, required this.isOn});

  @override
  Widget build(BuildContext context) {
    const double buttonRadius = 7;
    return ThemeBuilder(builder: (theme, isDark) {
      final Color color = isOn
          ? isDark
              ? AppColors.secondary
              : AppColors.primary
          : Colors.grey;

      return Container(
        width: buttonRadius * 5,
        height: (buttonRadius * 2.5) + 4,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(width: 1, color: color),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              curve: Curves.bounceInOut,
              duration: const Duration(milliseconds: 200),
              alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
              child: CircleAvatar(backgroundColor: color, radius: buttonRadius),
            ),
          ],
        ),
      );
    });
  }
}
