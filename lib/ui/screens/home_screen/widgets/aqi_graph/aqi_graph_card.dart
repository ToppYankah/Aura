import 'package:aura/helpers/navigation.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/app_text_button.dart';
import 'package:aura/ui/global_components/section_card_title.dart';
import 'package:aura/ui/global_components/section_card.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/home_screen/widgets/aqi_graph/aqi_graph.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AQIGraphCard extends StatelessWidget {
  const AQIGraphCard({super.key});

  void _onTap(context) => Navigation.openAQIDetailsScreen(context);

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      return LayoutBuilder(builder: (context, constraint) {
        final double width = constraint.maxWidth * 0.4;
        return SectionCard(
          onTap: () => _onTap(context),
          showInteractiveIndicator: false,
          title: const SectionCardTitle("AQI", icon: Iconsax.radar),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0)
                .copyWith(bottom: 10),
            child: Column(
              children: [
                AQIGraph(size: width),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: AppTextButton(
                    text: "See More",
                    enableBackground: true,
                    color: AppColors.secondary.shade600,
                    onTap: () => _onTap(context),
                  ),
                )
              ],
            ),
          ),
        );
      });
    });
  }
}
