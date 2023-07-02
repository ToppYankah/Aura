import 'package:aura/helpers/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

enum NotificationType { system, personalized, news }

class ContactMode {
  final String name;
  final IconData icon;
  final Function(BuildContext) action;

  const ContactMode(
      {required this.name, required this.action, required this.icon});
}

class SettingsUtil {
  SettingsUtil._();

  static const String mailScheme = 'mailto';

  static List<ContactMode> contactModes = [
    ContactMode(
      name: "Call",
      icon: Iconsax.call,
      action: (BuildContext context) => CommonUtils.callUs(context),
    ),
    ContactMode(
      name: "Send Email",
      icon: Iconsax.sms,
      action: (BuildContext context) => CommonUtils.sendEmail(context),
    ),
  ];

  static String notificationTypeString(NotificationType type) {
    switch (type) {
      case NotificationType.news:
        return "News";
      case NotificationType.personalized:
        return "Personalized";
      default:
        return "System";
    }
  }
}
