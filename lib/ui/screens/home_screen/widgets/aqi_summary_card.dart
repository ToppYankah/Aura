import 'package:aura/helpers/navigation.dart';
import 'package:aura/helpers/utils/aqi_util.dart';
import 'package:aura/providers/measurements_provider.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/ui/global_components/section_card_title.dart';
import 'package:aura/ui/global_components/section_card.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class AQISummaryCard extends StatelessWidget {
  const AQISummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      return SectionCard(
        onTap: () => Navigation.openAQISummaryScreen(context),
        margin: const EdgeInsets.only(bottom: 10),
        title: const SectionCardTitle(
          "AQI Summary",
          icon: Iconsax.document,
        ),
        // background: ,
        child: Consumer<MeasurementsProvider>(builder: (context, provider, _) {
          final AQIDetails? details = provider.aqiDetails;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0)
                .copyWith(bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    details?.status.message ?? "\n\n\n",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.paragraph),
                  ),
                ),
                Container(
                  width: 80,
                  height: 70,
                  margin: const EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: theme.background,
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: 30, cornerSmoothing: 1),
                  ),
                  child: Center(
                    child: details != null
                        ? Image(image: details.status.icon, width: 50)
                        : Text(
                            "?",
                            style: TextStyle(
                              fontSize: 30,
                              color: theme.heading,
                              fontFamily: AppFonts.gilroyFont,
                            ),
                          ),
                  ),
                )
              ],
            ),
          );
        }),
      );
    });
  }
}
