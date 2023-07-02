import 'package:aura/providers/measurements_provider.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverviewDisplayValue extends StatelessWidget {
  const OverviewDisplayValue({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MeasurementsProvider>(builder: (context, provider, _) {
      return ThemeBuilder(
        builder: (theme, _) {
          return Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ValueTypeButon(
                      label: "US AQI",
                      active: provider.useAQIValue,
                      onTap: () => provider.setUseAQIValue = true,
                    ),
                    Icon(EvaIcons.stopCircle,
                        size: 20, color: theme.background),
                    ValueTypeButon(
                      label: "PM2.5",
                      active: !provider.useAQIValue,
                      onTap: () => provider.setUseAQIValue = false,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

class ValueTypeButon extends StatelessWidget {
  final bool active;
  final String label;
  final VoidCallback? onTap;

  const ValueTypeButon({
    super.key,
    this.onTap,
    this.active = false,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: active ? AppColors.secondary : Colors.white12,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: active ? FontWeight.w500 : FontWeight.w700,
              color: active ? AppColors.primary : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
