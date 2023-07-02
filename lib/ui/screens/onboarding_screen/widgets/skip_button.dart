import 'package:aura/helpers/navigation.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

  void _handleSkipScreen(BuildContext context) async {
    Navigation.openRequestLocationScreen(context);

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(PreferenceKeys.IS_FIRST_TIME_LAUNCH, false);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: SafeArea(
        bottom: false,
        child: ThemeBuilder(builder: (theme, isDark) {
          final Color color = isDark ? AppColors.secondary : AppColors.primary;
          final Color background = isDark
              ? AppColors.secondary.withOpacity(0.2)
              : theme.cardBackground!;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: InkWell(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 25,
                cornerSmoothing: 0.8,
              ),
              onTap: () => _handleSkipScreen(context),
              highlightColor: AppColors.primary.withOpacity(0.3),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: SmoothBorderRadius(
                    cornerRadius: 25,
                    cornerSmoothing: 0.8,
                  ),
                ),
                child: Wrap(
                  spacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 14,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      EvaIcons.arrowheadRightOutline,
                      color: color,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
