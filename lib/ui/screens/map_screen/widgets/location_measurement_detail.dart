import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/app_icon_button.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/home_screen/widgets/aqi_graph/aqi_graph.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class LocationMeasurementDetails extends StatelessWidget {
  const LocationMeasurementDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? theme.background : theme.cardBackground,
            borderRadius: const SmoothBorderRadius.all(
              SmoothRadius(cornerRadius: 30, cornerSmoothing: 0.8),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppIconButton(
                      radius: 13,
                      iconSize: 13,
                      icon: EvaIcons.close,
                    ),
                  ],
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "University of Cape Coast",
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.heading,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "City, Country",
                            style: TextStyle(
                              height: 2,
                              fontSize: 16,
                              color: theme.paragraph,
                            ),
                          ),
                          Wrap(
                            spacing: 10,
                            children: [
                              Text(
                                "PM25 Reading:",
                                style: TextStyle(
                                  height: 2,
                                  fontSize: 14,
                                  color: theme.paragraph,
                                ),
                              ),
                              const Text(
                                "25.3",
                                style: TextStyle(
                                  height: 2,
                                  fontSize: 14,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AQIGraph(size: 65, textSize: 20, thickness: 3),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
