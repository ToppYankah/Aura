import 'package:aura/ui/global_components/app_switch_button.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class SettingsOption extends StatelessWidget {
  final bool value;
  final String label;
  final bool hasSwitch;
  final String? subLabel;
  final Function(bool value)? onTap;

  const SettingsOption({
    super.key,
    this.onTap,
    this.subLabel,
    this.value = false,
    required this.label,
    this.hasSwitch = false,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => (onTap ?? (_) {})(!value),
            borderRadius:
                SmoothBorderRadius(cornerRadius: 25, cornerSmoothing: 0.8),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: hasSwitch ? 15 : 17, horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                              color: theme.paragraphDeep, fontSize: 16),
                        ),
                        if (subLabel != null)
                          Opacity(
                            opacity: 0.7,
                            child: Text(
                              subLabel!,
                              style: TextStyle(
                                  color: theme.paragraph, fontSize: 13),
                            ),
                          )
                      ],
                    ),
                  ),
                  if (hasSwitch)
                    AppSwitchButton(
                      isOn: value,
                    )
                  // Switch(
                  //   value: value,
                  //   focusColor: AppColors.secondary,
                  //   activeColor: AppColors.secondary,
                  //   onChanged: (_) => (onTap ?? (_) {})(_),
                  // )
                  else
                    Icon(
                      IconlyLight.arrow_right_2,
                      color: theme.paragraph,
                      size: 20,
                    )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
