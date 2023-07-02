import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/onboarding_screen/data/onboarding_screen_data.dart';
import 'package:flutter/material.dart';

class OnboardingInfoSection extends StatelessWidget {
  final int index;
  const OnboardingInfoSection({super.key, this.index = 0});

  @override
  Widget build(BuildContext context) {
    final OnboardingInfo info = OnboardingScreenData.data[index];

    return ThemeBuilder(
      builder: (theme, isDark) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                info.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  color: theme.heading,
                  fontWeight: isDark ? FontWeight.w300 : FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                info.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: theme.paragraph,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
