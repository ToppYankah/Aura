// ignore_for_file: use_build_context_synchronously

import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/providers/location_provider.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/app_text_button.dart';
import 'package:aura/ui/global_components/section_card.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class LocationNotifier extends StatefulWidget {
  const LocationNotifier({super.key});

  @override
  State<LocationNotifier> createState() => _LocationNotifierState();
}

class _LocationNotifierState extends State<LocationNotifier> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, provider, _) {
        return provider.usingCurrentLocation
            ? const SizedBox()
            : ThemeBuilder(
                builder: (theme, isDark) => SectionCard(
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: isDark
                              ? AppColors.secondary.shade400
                              : AppColors.secondary.shade100,
                          child: Icon(Iconsax.location5,
                              size: 22,
                              color: isDark
                                  ? theme.background
                                  : AppColors.secondary),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "You're now viewing from a different location.",
                              style: TextStyle(
                                color: theme.paragraphDeep,
                              ),
                            ),
                          ),
                        ),
                        AppTextButton(
                          textSize: 12,
                          paddingSpace: 15,
                          text: "Use Current",
                          enableBackground: true,
                          disabled: provider.isLoading,
                          color: isDark
                              ? AppColors.secondary.shade300
                              : AppColors.secondary.shade600,
                          onTap: () async {
                            await CommonUtils.requiresGPSPermission(
                              context,
                              provider.getUserCurrentLocation,
                            );

                            CommonUtils.saveLocationAsReferenceForMeasurement(
                              context,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
