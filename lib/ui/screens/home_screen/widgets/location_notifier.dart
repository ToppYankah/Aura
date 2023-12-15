// ignore_for_file: use_build_context_synchronously

import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/providers/location_provider.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/section_card.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class CurrentLocationNotifier extends StatefulWidget {
  const CurrentLocationNotifier({super.key});

  @override
  State<CurrentLocationNotifier> createState() =>
      _CurrentLocationNotifierState();
}

class _CurrentLocationNotifierState extends State<CurrentLocationNotifier> {
  void _handleUseLocation() async {
    final provider = Provider.of<LocationProvider>(context, listen: false);

    await CommonUtils.callLoader(context, () async {
      await CommonUtils.requiresGPSPermission(
        context,
        provider.getUserCurrentLocation,
      );
    });

    CommonUtils.saveLocationAsReferenceForMeasurement(
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, provider, _) {
        return provider.usingCurrentLocation
            ? const SizedBox()
            : ThemeBuilder(
                builder: (theme, isDark) => SectionCard(
                  onTap: _handleUseLocation,
                  showInteractiveIndicator: false,
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: isDark
                              ? AppColors.secondary.shade600
                              : AppColors.secondary.shade200,
                          child: Icon(
                            Iconsax.magicpen5,
                            size: 20,
                            color: isDark
                                ? theme.background
                                : AppColors.secondary.shade600,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "It appears that this present sensor is quite distant from your location.",
                                  style: TextStyle(
                                    color: theme.paragraphDeep,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Builder(builder: (context) {
                                  final color = isDark
                                      ? AppColors.secondary
                                      : AppColors.secondary.shade600;
                                  return Wrap(
                                    spacing: 10,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Text(
                                        "Find closest sensor",
                                        style: TextStyle(
                                          color: color,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Icon(
                                        Iconsax.arrow_right_1,
                                        color: color,
                                        size: 20,
                                      )
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
