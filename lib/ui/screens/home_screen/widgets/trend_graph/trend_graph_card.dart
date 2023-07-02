import 'dart:developer';
import 'package:aura/helpers/navigation.dart';
import 'package:aura/providers/measurements_provider.dart';
import 'package:aura/ui/global_components/app_text_button.dart';
import 'package:aura/ui/global_components/section_card_title.dart';
import 'package:aura/ui/global_components/section_card.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/readings_screen/widgets/latest_reading_chart.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadingsGraphCard extends StatelessWidget {
  const ReadingsGraphCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      onTap: () => Navigation.openForecastScreen(context),
      title: SectionCardTitle(
        "Readings",
        icon: EvaIcons.trendingUpOutline,
        trailing:
            Consumer<MeasurementsProvider>(builder: (context, provider, _) {
          final int dayNumber = provider.selectedDate.day;
          final String dayName =
              provider.selectedDate.format('dddd').substring(0, 3);
          return ThemeBuilder(builder: (theme, _) {
            return AppTextButton(
              textSize: 12,
              enableBackground: true,
              color: theme.paragraphDeep,
              text: "$dayNumber - $dayName",
            );
          });
        }),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => log("Graph Tapped!!"),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: LatestReadingsChart(
            size: 120,
            withVerticalLines: true,
            showAxis: false,
          ),
        ),
      ),
    );
  }
}
