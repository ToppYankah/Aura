import 'package:aura/providers/settings/settings_provider.dart';
import 'package:aura/resources/sizes.dart';
import 'package:aura/ui/global_components/app_radio_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntervalEditModal extends StatelessWidget {
  final VoidCallback? onClose;
  const IntervalEditModal({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(builder: (context, provider, _) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: Sizes.refreshIntervals.map((interval) {
          return Material(
            color: Colors.transparent,
            child: ListTile(
              onTap: () => provider.refreshInterval = interval,
              title: Text(provider.intervalDescription(value: interval)),
              trailing: AppRadioButton(
                  active: interval == provider.prefs.refreshInterval),
            ),
          );
        }).toList(),
      );
    });
  }
}
