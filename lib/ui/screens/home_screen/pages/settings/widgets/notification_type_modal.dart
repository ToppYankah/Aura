import 'package:aura/helpers/utils/settings_util.dart';
import 'package:aura/providers/settings/settings_provider.dart';
import 'package:aura/ui/global_components/app_switch_button.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationTypeEditModal extends StatelessWidget {
  final VoidCallback? onClose;
  const NotificationTypeEditModal({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(builder: (context, provider, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: NotificationType.values.map((type) {
          final bool active = provider.prefs.notificationTypes.contains(type);
          return ClipRRect(
            borderRadius: const SmoothBorderRadius.all(
              SmoothRadius(cornerRadius: 20, cornerSmoothing: 0.8),
            ),
            child: Material(
              color: Colors.transparent,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                onTap: () {
                  if (active) {
                    provider.removeNotificationType = type;
                  } else {
                    provider.addNotificationType = type;
                  }
                },
                trailing: AppSwitchButton(isOn: active),
                title: Text(
                  SettingsUtil.notificationTypeString(type),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}
