import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/onboarding_screen/data/onboarding_screen_data.dart';
import 'package:flutter/material.dart';

class PaginationIndicator extends StatelessWidget {
  final int index;
  const PaginationIndicator({super.key, this.index = 0});

  @override
  Widget build(BuildContext context) {
    final OnboardingInfo active = OnboardingScreenData.data[index];

    return ThemeBuilder(
      builder: (theme, isDark) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30),
          child: Wrap(
            spacing: 8,
            children: OnboardingScreenData.data
                .map(
                  (item) => AnimatedContainer(
                    width: 30,
                    height: 3,
                    duration: const Duration(milliseconds: 300),
                    color: active == item ? AppColors.primary : theme.border,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
