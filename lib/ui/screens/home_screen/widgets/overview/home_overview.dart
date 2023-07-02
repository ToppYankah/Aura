import 'package:aura/network/response.dart';
import 'package:aura/providers/location_provider.dart';
import 'package:aura/providers/measurements_provider.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/resources/app_images.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/ui/global_components/app_loader/app_loader.dart';
import 'package:aura/ui/global_components/section_card.dart';
import 'package:aura/ui/global_components/street_name_text.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/home_screen/widgets/header/home_header.dart';
import 'package:aura/ui/screens/home_screen/widgets/overview/display_value.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class HomeOverview extends StatelessWidget {
  const HomeOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      return SectionCard(
        useHorizontalSpace: false,
        corners: CardCorners.bottom,
        background: AppColors.primary,
        margin: const EdgeInsets.only(bottom: 10),
        child: Stack(
          children: [
            const Positioned.fill(
              child: Opacity(
                opacity: 0.5,
                child:
                    Image(image: AppImages.cardBackground, fit: BoxFit.cover),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Column(
                  children: [
                    const HomeHeader(),
                    _renderLocationDetails(context),
                    _renderAQIRangeStatus(),
                    const OverviewDisplayValue(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _renderAQIRangeStatus() {
    return Consumer<MeasurementsProvider>(
      builder: (context, provider, _) {
        return Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10).copyWith(bottom: 0),
              child: Stack(
                children: [
                  Opacity(
                    opacity: provider.isLoading ? 0 : 1,
                    child: Text(
                      provider.displayValue,
                      style: const TextStyle(
                        fontSize: 80,
                        color: Colors.white,
                        fontFamily: AppFonts.gilroyFont,
                      ),
                    ),
                  ),
                  if (provider.isLoading)
                    const Positioned.fill(
                      child: Center(
                        child: AppLoader(
                          size: 40,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Wrap(
              spacing: 5,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Icon(
                  Icons.air_rounded,
                  color: Colors.white70,
                  size: 20,
                ),
                Text(
                  provider.aqiDetails?.status.name ?? "Unknown Status",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Wrap(
                spacing: 5,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Icon(
                    IconlyBold.time_circle,
                    color: Colors.white70,
                    size: 17,
                  ),
                  Text(
                    provider.lastUpdated,
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _renderLocationDetails(BuildContext context) {
    return Consumer<LocationProvider>(builder: (context, provider, _) {
      final String locationName =
          provider.selectedLocation?.name ?? "Unknown Location";
      final Coordinates? coords = provider.selectedLocation?.coordinates;
      final bool clipText = locationName.length >= 25;

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Icon(
                    IconlyBold.send,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  flex: clipText ? 1 : 0,
                  child: Text(
                    locationName,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          StreetNameText(
            coords: coords!,
            withCountry: true,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    });
  }
}
