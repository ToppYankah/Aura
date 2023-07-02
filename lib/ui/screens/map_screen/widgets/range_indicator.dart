import 'package:aura/helpers/utils/aqi_util.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class RangeIndicator extends StatelessWidget {
  const RangeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          decoration: BoxDecoration(
            color: isDark ? theme.background : theme.cardBackground,
            borderRadius:
                SmoothBorderRadius(cornerRadius: 20, cornerSmoothing: 0.8),
          ),
          child: Row(
            children: AQIUtil.statuses
                .map(
                  (status) => Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            "${status.range.min.round()} - ${status.range.max.round()}",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 10, color: theme.paragraph),
                          ),
                        ),
                        Container(
                          height: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: status.color,
                            borderRadius: SmoothBorderRadius(
                                cornerRadius: 30, cornerSmoothing: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    });
  }
}
