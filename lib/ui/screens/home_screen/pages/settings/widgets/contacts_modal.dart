import 'package:aura/helpers/utils/settings_util.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ContactsModal extends StatelessWidget {
  final VoidCallback? onClose;
  const ContactsModal({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      final color = isDark ? AppColors.secondary : AppColors.primary;
      final background = color.withOpacity(0.1);
      return Column(
        children: SettingsUtil.contactModes.map(
          (mode) {
            return ClipRRect(
              borderRadius: const SmoothBorderRadius.all(
                SmoothRadius(cornerRadius: 30, cornerSmoothing: 0.8),
              ),
              child: Material(
                color: Colors.transparent,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: background,
                    child: Icon(mode.icon, size: 18, color: color),
                  ),
                  onTap: () async {
                    (onClose ?? () {})();
                    mode.action(context);
                  },
                  trailing: const Icon(Iconsax.arrow_right_3, size: 18),
                  title: Text(mode.name, style: const TextStyle(fontSize: 16)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
              ),
            );
          },
        ).toList(),
      );
    });
  }
}
