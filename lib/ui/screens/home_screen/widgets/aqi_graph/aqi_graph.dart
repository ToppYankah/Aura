import 'package:aura/providers/measurements_provider.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/home_screen/widgets/aqi_graph/aqi_range_paint.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AQIGraph extends StatelessWidget {
  final double size;
  final double textSize;
  final double thickness;
  const AQIGraph(
      {super.key, required this.size, this.thickness = 5, this.textSize = 25});

  @override
  Widget build(BuildContext context) {
    double fontSize = textSize * 0.6;
    if (fontSize < 15) fontSize = 15;
    if (fontSize > 20) fontSize = 20;

    return ThemeBuilder(builder: (theme, isDark) {
      return Consumer<MeasurementsProvider>(builder: (context, provider, _) {
        double progressValue = (provider.aqiDetails?.value ?? 0) / 500;
        if (progressValue > 1) progressValue = 1;

        return CircleAvatar(
          radius: size,
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              Center(
                child: CustomPaint(
                  painter: AQIRangePaint(
                    thickness: thickness,
                    radius: size,
                    progress: progressValue,
                    borderColor: isDark ? Colors.white : theme.cardBackground!,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      provider.aqiDisplayValue,
                      style: TextStyle(
                        fontSize: textSize,
                        color: theme.heading,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppFonts.gilroyFont,
                      ),
                    ),
                    Text(
                      "AQI",
                      style: TextStyle(
                        fontSize: fontSize,
                        color: theme.paragraph,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
