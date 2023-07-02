import 'package:aura/resources/app_svgs.dart';
import 'package:aura/ui/global_components/app_header.dart';
import 'package:aura/ui/global_components/empty_list.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/home_screen/data/home_screen_data.dart';
import 'package:flutter/material.dart';

class NotificationPage extends HomePageItem {
  final List<dynamic> notifications;
  const NotificationPage(
      {super.key, required super.onPagePop, this.notifications = const []});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ThemeBuilder(builder: (theme, isDark) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppHeader(title: "Notifications", onBack: onPagePop),
            Expanded(
              child: notifications.isEmpty
                  ? EmptyList(
                      disabled: false,
                      onReload: () {},
                      message: "Notifications Empty",
                      customSvg: AppSvgs.notification,
                    )
                  : const SingleChildScrollView(
                      child: Column(children: []),
                    ),
            ),
          ],
        );
      }),
    );
  }
}
