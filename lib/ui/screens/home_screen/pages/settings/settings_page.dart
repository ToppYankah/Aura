import 'package:aura/helpers/navigation.dart';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/providers/settings/settings_provider.dart';
import 'package:aura/providers/theme_provider.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/ui/global_components/app_header.dart';
import 'package:aura/ui/global_components/app_modal/modal_model.dart';
import 'package:aura/ui/global_components/section_card_title.dart';
import 'package:aura/ui/global_components/section_card.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/home_screen/data/home_screen_data.dart';
import 'package:aura/ui/screens/home_screen/pages/settings/widgets/contacts_modal.dart';
import 'package:aura/ui/screens/home_screen/pages/settings/widgets/interval_modal.dart';
import 'package:aura/ui/screens/home_screen/pages/settings/widgets/notification_type_modal.dart';
import 'package:aura/ui/screens/home_screen/pages/settings/widgets/settings_option.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';

class SettingsPage extends HomePageItem {
  const SettingsPage({super.key, required super.onPagePop});

  void _handleEditRefreshInterval(BuildContext context) {
    CommonUtils.showModal(
      context,
      child: (VoidCallback onClose) => IntervalEditModal(onClose: onClose),
      options: const ModalOptions(
        backgroundDismissible: true,
        title: "Select Interval",
      ),
    );
  }

  void _handleEditNotificationTypes(BuildContext context) {
    CommonUtils.showModal(
      context,
      child: (VoidCallback onClose) =>
          NotificationTypeEditModal(onClose: onClose),
      options: const ModalOptions(
        backgroundDismissible: true,
        title: "Select Notification Types",
      ),
    );
  }

  void _handleContactUsTap(BuildContext context) {
    CommonUtils.showModal(
      context,
      child: (VoidCallback onClose) => ContactsModal(onClose: onClose),
      options: const ModalOptions(
        backgroundDismissible: true,
        useHorizontalPadding: false,
        title: "Select mode",
      ),
    );
  }

  void _handleRateApp() {
    final InAppReview inAppReview = InAppReview.instance;
    inAppReview.openStoreListing(appStoreId: AppStrings.appStoreID);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppHeader(title: "Settings", onBack: onPagePop),
          ThemeBuilder(builder: (theme, isDark) {
            return Expanded(
              child:
                  Consumer<SettingsProvider>(builder: (context, provider, _) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 20),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SectionCard(
                        title: const SectionCardTitle(
                          "Display",
                          icon: Icons.brightness_4_rounded,
                        ),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            children: [
                              SettingsOption(
                                label: "Refresh Interval",
                                subLabel: provider.intervalDescription(
                                    explicit: true),
                                onTap: (_) =>
                                    _handleEditRefreshInterval(context),
                              ),
                              SettingsOption(
                                label: "Notification Types",
                                subLabel: provider.notificationTypeDescription,
                                onTap: (_) =>
                                    _handleEditNotificationTypes(context),
                              ),
                              SettingsOption(
                                value: isDark,
                                hasSwitch: true,
                                label: "Dark Theme",
                                onTap: (_) => Provider.of<ThemeProvider>(
                                        context,
                                        listen: false)
                                    .toggleTheme(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SectionCard(
                        title: const SectionCardTitle(
                          "Permissions",
                          icon: Iconsax.shield_tick5,
                        ),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            children: [
                              SettingsOption(
                                hasSwitch: true,
                                label: "Location",
                                // subLabel: "Enable/Disable location access",
                                value: provider.permissions.allowLocationAccess,
                                onTap: (value) =>
                                    provider.allowLocationAccess = value,
                              ),
                              SettingsOption(
                                hasSwitch: true,
                                label: "Allow Notifications",
                                // subLabel: "Tips & alerts when necessary",
                                value: provider.permissions.allowNotifications,
                                onTap: (value) =>
                                    provider.allowNotifications = value,
                              ),
                              SettingsOption(
                                hasSwitch: true,
                                label: "Auto Check for Updates",
                                // subLabel: "Auto check for updates on startup",
                                value:
                                    provider.permissions.allowAutoCheckUpdates,
                                onTap: (value) =>
                                    provider.allowAutoCheckUpdates = value,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SectionCard(
                        title: const SectionCardTitle(
                          "Help",
                          icon: Iconsax.message_question5,
                        ),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            children: [
                              // SettingsOption(
                              //   label: "About",
                              //   onTap: (_) => Navigation.openAbout(context),
                              // ),
                              SettingsOption(
                                label: "Contact Us",
                                onTap: (_) => _handleContactUsTap(context),
                              ),
                              SettingsOption(
                                label: "Report Issue",
                                onTap: (_) => Navigation.openMailForm(context),
                              ),
                              SettingsOption(
                                label: "Rate App",
                                onTap: (_) => _handleRateApp(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}
