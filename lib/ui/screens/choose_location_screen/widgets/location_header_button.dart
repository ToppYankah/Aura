import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class HeaderButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final VoidCallback? onTap;
  const HeaderButton(
      {super.key, required this.icon, this.onTap, this.iconSize = 30});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, _) {
      return ClipSmoothRect(
        clipBehavior: Clip.hardEdge,
        radius: SmoothBorderRadius(
          cornerRadius: 18,
          cornerSmoothing: 0.8,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: SmoothBorderRadius(
            cornerRadius: 18,
            cornerSmoothing: 0.8,
          ),
          child: Container(
            width: 50,
            height: 60,
            alignment: Alignment.center,
            color: theme.cardBackground,
            child: ClipSmoothRect(
              radius: SmoothBorderRadius(
                cornerRadius: 18,
                cornerSmoothing: 0.8,
              ),
              child: Icon(
                icon,
                size: iconSize,
                color: theme.paragraphDeep,
              ),
            ),
          ),
        ),
      );
    });
  }
}
