import 'dart:math';

import 'package:aura/resources/app_colors.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/readings_screen/models/graph_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BezierCurveGraph<T> extends StatelessWidget {
  final double yMax;
  final double height;
  final bool showAxis;
  final double barThickness;
  final List<GraphData> data;
  final bool useVerticalLines;
  final DateTime? visibleMinimum, visibleMaximum;

  const BezierCurveGraph({
    super.key,
    this.height = 120,
    required this.data,
    required this.yMax,
    this.visibleMinimum,
    this.visibleMaximum,
    this.showAxis = true,
    this.barThickness = 5,
    this.useVerticalLines = false,
  });

  @override
  Widget build(BuildContext context) {
    List<Offset> chartData = [];

    for (double i = 0; i < 10; i++) {
      int min = 3;
      int max = 8;
      final rnd = Random();
      final y = min + rnd.nextInt(max - min);
      chartData.add(Offset(i, y.toDouble()));
    }

    Widget _tooltipBuilder(data, point, series, pointIndex, seriesIndex) {
      final String value = data.y.toStringAsFixed(1);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
        child: RichText(
          text: TextSpan(
            text: value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.darkBackground,
              fontFamily: AppFonts.gilroyFont,
            ),
            children: const [
              TextSpan(
                text: " µg/m³",
                // text: data.unit,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.darkBackground,
                  fontFamily: AppFonts.lufgaFont,
                ),
              )
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return ThemeBuilder(builder: (theme, isDark) {
          final Color labelColor = theme.paragraph!.withOpacity(0.5);
          final Color gridLines =
              isDark ? Colors.white10 : AppColors.primary.withOpacity(0.1);

          return SizedBox(
            height: height,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              tooltipBehavior: TooltipBehavior(
                header: "",
                elevation: 0,
                enable: true,
                canShowMarker: true,
                builder: _tooltipBuilder,
                color: AppColors.secondary,
              ),
              primaryXAxis: DateTimeAxis(
                // isVisible: showAxis,
                visibleMaximum: visibleMaximum,
                visibleMinimum: visibleMinimum,
                intervalType: DateTimeIntervalType.minutes,
                axisLine: AxisLine(width: 2, color: gridLines),
                majorTickLines: const MajorTickLines(width: 0),
                labelStyle: TextStyle(
                    color: labelColor, fontFamily: AppFonts.lufgaFont),
                majorGridLines: MajorGridLines(
                    width: useVerticalLines ? 1 : 0, color: gridLines),
              ),
              primaryYAxis: NumericAxis(
                maximum: yMax,
                isVisible: showAxis,
                majorTickLines: const MajorTickLines(width: 0),
                axisLine: const AxisLine(color: Colors.transparent),
                labelStyle: TextStyle(
                    color: labelColor, fontFamily: AppFonts.lufgaFont),
                majorGridLines: MajorGridLines(
                    width: useVerticalLines ? 0 : 1, color: gridLines),
              ),
              zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true,
                enablePinching: true,
                zoomMode: ZoomMode.x,
              ),
              series: <ChartSeries<GraphData, T>>[
                // Renders spline chart

                SplineRangeAreaSeries<GraphData, T>(
                  borderWidth: 1,
                  dataSource: data,
                  lowValueMapper: (GraphData data, _) => 0,
                  xValueMapper: (GraphData data, _) => data.x,
                  highValueMapper: (GraphData data, _) => data.y,
                  onCreateShader: (details) => LinearGradient(
                    colors: [
                      AppColors.secondary.withOpacity(isDark ? 0.2 : 0.5),
                      AppColors.secondary.withOpacity(0.01),
                      // AppColors.secondary.withOpacity(0.02),
                    ],
                    end: Alignment.bottomCenter,
                    begin: Alignment.topCenter,
                  ).createShader(
                    Rect.fromPoints(
                      details.rect.topCenter,
                      details.rect.bottomCenter,
                    ),
                  ),
                ),
                SplineSeries<GraphData, T>(
                  width: 5,
                  dataSource: data,
                  enableTooltip: true,
                  color: AppColors.secondary,
                  markerSettings: MarkerSettings(
                    width: 5,
                    height: 5,
                    borderWidth: 0,
                    isVisible: true,
                    borderColor: theme.background,
                    color: AppColors.secondary.shade200,
                  ),
                  xValueMapper: (GraphData data, _) => data.x,
                  yValueMapper: (GraphData data, _) => data.y,
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
