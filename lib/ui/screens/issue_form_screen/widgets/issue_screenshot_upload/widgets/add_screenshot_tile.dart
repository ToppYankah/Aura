import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AddScreenshotTile extends StatelessWidget {
  final Size size;
  final VoidCallback onAdd;
  const AddScreenshotTile({super.key, required this.size, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      final Color color = isDark ? Colors.white : Colors.grey;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onAdd,
          borderRadius:
              SmoothBorderRadius(cornerRadius: 20, cornerSmoothing: 0.8),
          child: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius:
                  SmoothBorderRadius(cornerRadius: 20, cornerSmoothing: 0.8),
            ),
            child: Center(
              child: CircleAvatar(
                radius: 25,
                backgroundColor: color.withOpacity(0.3),
                child: Icon(Iconsax.add, color: color),
              ),
            ),
          ),
        ),
      );
    });
  }
}
