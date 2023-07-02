import 'package:aura/resources/app_colors.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/readings_screen/models/graph_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MinMaxReadingGraph<T> extends StatelessWidget {
  final double yMax;
  final double height;
  final double barThickness;
  final List<MinMaxGraphData> data;
  final DateTime? visibleMinimum, visibleMaximum;

  const MinMaxReadingGraph({
    super.key,
    this.height = 120,
    required this.data,
    required this.yMax,
    this.visibleMinimum,
    this.visibleMaximum,
    this.barThickness = 5,
  });

  @override
  Widget build(BuildContext context) {
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
                color: isDark ? AppColors.secondary : AppColors.primary,
              ),
              zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true,
                enablePinching: true,
                zoomMode: ZoomMode.x,
              ),
              primaryXAxis: DateTimeAxis(
                visibleMinimum: visibleMinimum,
                visibleMaximum: visibleMaximum,
                intervalType: DateTimeIntervalType.hours,
                axisLine: AxisLine(width: 0, color: gridLines),
                majorTickLines: const MajorTickLines(width: 0),
                labelStyle: TextStyle(
                    color: labelColor, fontFamily: AppFonts.lufgaFont),
                majorGridLines: MajorGridLines(width: 0, color: gridLines),
              ),
              primaryYAxis: NumericAxis(
                maximum: yMax,
                visibleMaximum: yMax,
                majorTickLines: const MajorTickLines(width: 0),
                axisLine: const AxisLine(color: Colors.transparent),
                labelStyle: TextStyle(
                    color: labelColor, fontFamily: AppFonts.lufgaFont),
                majorGridLines: MajorGridLines(width: 1, color: gridLines),
              ),
              series: <ChartSeries<MinMaxGraphData, T>>[
                // Renders spline chart
                CandleSeries<MinMaxGraphData, T>(
                  dataSource: data,
                  enableTooltip: true,
                  borderWidth: barThickness,
                  bearColor: AppColors.primary,
                  bullColor: AppColors.secondary,
                  openValueMapper: (MinMaxGraphData item, _) => 0,
                  closeValueMapper: (MinMaxGraphData item, _) => 0,
                  xValueMapper: (MinMaxGraphData item, _) => item.x,
                  lowValueMapper: (MinMaxGraphData item, _) => item.y,
                  highValueMapper: (MinMaxGraphData item, _) => item.yMax,
                )
              ],
            ),
          );
        });
      },
    );
  }
}

class GraphToolTip extends StatelessWidget {
  final Color color;
  final GraphData data;
  const GraphToolTip(
      {super.key, required this.data, this.color = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data.y.round().toString(),
            style: TextStyle(
              fontSize: 18,
              color: color,
              fontFamily: AppFonts.gilroyFont,
            ),
          ),
          Text(
            data.unit,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontFamily: AppFonts.lufgaFont,
            ),
          ),
        ],
      ),
    );
  }
}

// onCreateShader: (details) => const LinearGradient(
                  //   colors: [
                  //     Color.fromARGB(255, 0, 255, 42),
                  //     Color.fromARGB(255, 255, 204, 0),
                  //     // Color.fromARGB(255, 255, 98, 0),
                  //     Color.fromARGB(255, 255, 98, 0),
                  //   ],
                  //   end: Alignment.topCenter,
                  //   begin: Alignment.bottomCenter,
                  // ).createShader(
                  //   Rect.fromPoints(
                  //     const Offset(0, 0),
                  //     Offset(constraints.maxWidth, 90),
                  //   ),
                  // ),