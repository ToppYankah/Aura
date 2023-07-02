import 'package:aura/helpers/navigation.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/resources/app_images.dart';
import 'package:aura/ui/global_components/app_text_button.dart';
import 'package:aura/ui/global_components/section_card.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class HealthTipsCard extends StatelessWidget {
  const HealthTipsCard({super.key});

  void _onTap(context) => Navigation.openHealthTipsScreen(context);

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (theme, isDark) {
        return SectionCard(
          onTap: () => _onTap(context),
          background: AppColors.primary,
          showInteractiveIndicator: false,
          margin: const EdgeInsets.only(bottom: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30)
                .copyWith(bottom: 20),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    width: 100,
                    // padding: const EdgeInsets.symmetric(vertical: 20),
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      // color: AppColors.primary.shade800,
                      borderRadius: SmoothBorderRadius(
                          cornerRadius: 30, cornerSmoothing: 1),
                    ),
                    child: const Center(
                      child: Image(
                          image: AppImages.atmospherePollution, height: 90),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 20.0),
                              child: Text(
                                "Actions you can take to reduce air pollution.",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          AppTextButton(
                            textSize: 14,
                            paddingSpace: 15,
                            color: Colors.white,
                            text: "Start Learning",
                            enableBackground: true,
                            icon: EvaIcons.arrowForward,
                            iconPosition: IconPosition.after,
                            onTap: () => _onTap(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
