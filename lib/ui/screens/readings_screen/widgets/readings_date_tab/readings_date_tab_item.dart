import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/readings_screen/models/date_info.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class DateTabItem extends StatelessWidget {
  final DateInfo date;
  final VoidCallback? onTap;
  final bool active, disabled;

  const DateTabItem(
      {super.key,
      this.active = false,
      required this.date,
      this.onTap,
      this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      return Expanded(
        child: Opacity(
          opacity: disabled ? 0.3 : 1,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active
                  ? isDark
                      ? AppColors.primary.shade400
                      : AppColors.primary
                  : Colors.transparent,
              borderRadius:
                  SmoothBorderRadius(cornerRadius: 28, cornerSmoothing: 0.8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: disabled ? null : onTap,
                borderRadius:
                    SmoothBorderRadius(cornerRadius: 28, cornerSmoothing: 0.8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 6),
                      child: Wrap(
                        spacing: 10,
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runAlignment: WrapAlignment.center,
                        children: [
                          Text(
                            date.day,
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  active ? Colors.white70 : theme.paragraphDeep,
                            ),
                          ),
                          Text(
                            date.dayNumber.toString().padLeft(2, "0"),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color:
                                  active ? Colors.white70 : theme.paragraphDeep,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
