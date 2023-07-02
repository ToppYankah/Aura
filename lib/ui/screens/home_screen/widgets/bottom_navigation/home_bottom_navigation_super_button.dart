import 'package:aura/helpers/navigation.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class BottomNavigationSuperItem extends StatelessWidget {
  const BottomNavigationSuperItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, _) {
      return GestureDetector(
        onTap: () => Navigation.openMap(context),
        child: Transform.translate(
          offset: const Offset(0, -20),
          child: Transform.scale(
            scale: 1.2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CircleAvatar(
                radius: 33,
                backgroundColor: theme.background,
                child: const CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary,
                  child: Icon(
                    IconlyBold.location,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
