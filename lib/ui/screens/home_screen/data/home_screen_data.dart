import 'package:aura/ui/screens/home_screen/pages/home/home_page.dart';
import 'package:aura/ui/screens/home_screen/pages/notification/notification_page.dart';
import 'package:aura/ui/screens/home_screen/pages/profile/profile_page.dart';
import 'package:aura/ui/screens/home_screen/pages/settings/settings_page.dart';
import 'package:aura/ui/screens/home_screen/widgets/bottom_navigation/home_bottom_navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

enum HomeScreenPage { home, notifications, settings, profile }

class HomePageItem extends StatelessWidget {
  const HomePageItem({super.key});

  @override
  Widget build(BuildContext context) => const Placeholder();
}

class HomeScreenConfig {
  HomeScreenConfig._();

  static Map<HomeScreenPage, HomePageItem> pages = {
    HomeScreenPage.home: const HomePage(),
    HomeScreenPage.profile: const ProfilePage(),
    HomeScreenPage.settings: const SettingsPage(),
    HomeScreenPage.notifications: const NotificationPage(),
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
