import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/home_screen/widgets/pollutant_info/concentration_meter_paint.dart';
import 'package:flutter/material.dart';

class PollutantDetail extends StatelessWidget {
  final String name;
  final Color color;
  final double ratio;
  final String average;
  final Animation animation;
  const PollutantDetail({
    super.key,
    required this.name,
    required this.animation,
    required this.average,
    required this.color,
    required this.ratio,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            spacing: 5,
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                average,
                style: TextStyle(
                  fontSize: 20,
                  color: theme.paragraphDeep,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: theme.paragraph!.withOpacity(0.2),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              return SizedBox(
                height: 40,
                child: CustomPaint(
                  painter: ConcentrationMeterPaint(
                    value: ratio * animation.value,
                    color: color,
                    trackColor: isDark
                        ? Colors.white10
                        : AppColors.primary.withOpacity(0.08),
                  ),
                ),
              );
            },
          ),
        ],
      );
    });
  }
}
