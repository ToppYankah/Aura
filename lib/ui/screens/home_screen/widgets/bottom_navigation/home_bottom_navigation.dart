import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/home_screen/data/home_screen_data.dart';
import 'package:aura/ui/screens/home_screen/widgets/bottom_navigation/home_bottom_navigation_item.dart';
import 'package:aura/ui/screens/home_screen/widgets/bottom_navigation/home_bottom_navigation_super_button.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class HomeBottomNavigation extends StatefulWidget {
  final HomeScreenPage currentPage;
  final List<HomeBottomNavigationItem?> navigationOptions;
  final void Function(HomeScreenPage page) onNavigationChange;

  const HomeBottomNavigation({
    super.key,
    required this.currentPage,
    required this.navigationOptions,
    required this.onNavigationChange,
  });

  @override
  State<HomeBottomNavigation> createState() => _HomeBottomNavigationState();
}

class _HomeBottomNavigationState extends State<HomeBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (theme, isDark) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            decoration: BoxDecoration(
              color: theme.background,
              border: Border.all(
                width: 1,
                color: theme.cardBackground!,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
              borderRadius: const SmoothBorderRadius.vertical(
                top: SmoothRadius(cornerRadius: 0, cornerSmoothing: 0.8),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _renderNavigationOptions(),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _renderNavigationOptions() {
    List<Widget> output = [];

    for (var item in widget.navigationOptions) {
      if (item == null) {
        output.add(const BottomNavigationSuperItem());
      } else {
        output.add(
          HomeBottomNavigationItem(
            id: item.id,
            icon: item.icon,
            activeIcon: item.activeIcon,
            active: item.id == widget.currentPage,
            onTap: () => widget.onNavigationChange(item.id),
          ),
        );
      }
    }

    return output;
  }
}
