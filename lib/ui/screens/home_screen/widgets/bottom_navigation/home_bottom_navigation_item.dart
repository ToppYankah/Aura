import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/home_screen/data/home_screen_data.dart';
import 'package:flutter/material.dart';

class HomeBottomNavigationItem extends StatelessWidget {
  final bool active;
  final IconData icon;
  final HomeScreenPage id;
  final IconData activeIcon;
  final VoidCallback? onTap;
  const HomeBottomNavigationItem({
    super.key,
    this.onTap,
    required this.id,
    required this.icon,
    this.active = false,
    required this.activeIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, _) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.transparent,
          child: Icon(
            active ? activeIcon : icon,
            size: 25,
            color: active ? AppColors.secondary : theme.paragraphDeep,
          ),
        ),
      );
    });
  }
}
