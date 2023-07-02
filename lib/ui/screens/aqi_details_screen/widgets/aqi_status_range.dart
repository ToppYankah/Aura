import 'package:aura/helpers/utils/aqi_util.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:flutter/material.dart';

class StatusRange extends StatelessWidget {
  final AQIStatus status;
  const StatusRange({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      return Wrap(
        spacing: 20,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            height: 10,
            width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: status.color,
            ),
          ),
          Text(
            "${status.range.min.round()} - ${status.range.max.round()}",
            style: TextStyle(
              color: theme.paragraphDeep,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      );
    });
  }
}
