import 'package:aura/providers/measurements_provider.dart';
import 'package:aura/ui/global_components/app_loader/app_loader.dart';
import 'package:aura/ui/global_components/column_chart_graph.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HourOfDayChart extends StatelessWidget {
  final double size;
  const HourOfDayChart({super.key, this.size = 200});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MeasurementsProvider>(context);

    return ThemeBuilder(builder: (theme, _) {
      return FutureBuilder(
          future: provider.getWeeklyMeasurements(),
          builder: (context, snapshot) {
            final bool isLoading =
                snapshot.connectionState == ConnectionState.waiting;
            return Stack(
              children: [
                if (isLoading)
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.center,
                      child: const AppLoader(size: 25),
                    ),
                  ),
                if (!isLoading && provider.weeklyMeasurements.isEmpty)
                  Positioned.fill(
                    child: ThemeBuilder(builder: (theme, _) {
                      return Container(
                        alignment: Alignment.center,
                        child: Text(
                          "There were no readings",
                          style: TextStyle(color: theme.paragraph),
                        ),
                      );
                    }),
                  ),
                Opacity(
                  opacity: isLoading || provider.weeklyMeasurements.isEmpty
                      ? 0.5
                      : 1,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: MinMaxReadingGraph<DateTime>(
                      height: size,
                      yMax: provider.patternsMaxReading,
                      data: provider.getPattern.toList(),
                      visibleMaximum: provider.selectedDate
                          .subtract(const Duration(days: 4)),
                      // provider.readingsVisibleMaximum(
                      //   hours: const Duration(hours: 20),
                      // ),
                    ),
                  ),
                ),
              ],
            );
          });
    });
  }
}
