import 'package:aura/ui/screens/home_screen/pages/home/home_page.dart';
import 'package:aura/ui/screens/home_screen/pages/notification/notification_page.dart';
import 'package:aura/ui/screens/home_screen/pages/profile/profile_page.dart';
import 'package:aura/ui/screens/home_screen/pages/settings/settings_page.dart';
import 'package:aura/ui/screens/home_screen/widgets/bottom_navigation/home_bottom_navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

enum HomeScreenPage { home, notifications, settings, profile }

class HomePageItem extends StatelessWidget {
  final VoidCallback onPagePop;
  const HomePageItem({super.key, required this.onPagePop});

  @override
  Widget build(BuildContext context) => const Placeholder();
}

class HomeScreenConfig {
  HomeScreenConfig._();

  static Map<HomeScreenPage, HomePageItem> pages(VoidCallback onPop) => {
        HomeScreenPage.home: HomePage(onPagePop: onPop),
        HomeScreenPage.profile: ProfilePage(onPagePop: onPop),
        HomeScreenPage.settings: SettingsPage(onPagePop: onPop),
        HomeScreenPage.notifications: NotificationPage(onPagePop: onPop),
      };

  static List<HomeBottomNavigationItem?> bottomNavigationOptions = const [
    HomeBottomNavigationItem(
      active: true,
      icon: IconlyLight.home,
      id: HomeScreenPage.home,
      activeIcon: IconlyBold.home,
    ),
    HomeBottomNavigationItem(
      icon: IconlyLight.notification,
      id: HomeScreenPage.notifications,
      activeIcon: IconlyBold.notification,
    ),
    null,
    HomeBottomNavigationItem(
      icon: IconlyLight.setting,
      id: HomeScreenPage.settings,
      activeIcon: IconlyBold.setting,
    ),
    HomeBottomNavigationItem(
      icon: IconlyLight.profile,
      id: HomeScreenPage.profile,
      activeIcon: IconlyBold.profile,
    ),
  ];
}
