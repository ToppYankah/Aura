import 'package:aura/providers/measurements_provider.dart';
import 'package:aura/ui/global_components/app_loader/app_loader.dart';
import 'package:aura/ui/global_components/bezier_curve_graph.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LatestReadingsChart extends StatelessWidget {
  final double size;
  final bool showAxis;
  final bool withVerticalLines;
  const LatestReadingsChart(
      {super.key,
      this.size = 200,
      this.withVerticalLines = false,
      this.showAxis = true});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MeasurementsProvider>(context);

    return Stack(
      children: [
        if (provider.isLoading)
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              child: const AppLoader(size: 25),
            ),
          ),
        if (!provider.isLoading && provider.aqiReadings.isEmpty)
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
          opacity: provider.isLoading || provider.aqiReadings.isEmpty ? 0.5 : 1,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: BezierCurveGraph<DateTime>(
              height: size,
              showAxis: showAxis,
              yMax: provider.maxReading,
              data: provider.readings.toList(),
              useVerticalLines: withVerticalLines,
              visibleMaximum: provider.readingsVisibleMaximum(),
            ),
          ),
        ),
      ],
    );
  }
}
