import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/network/api/locations/models/location_data.dart';
import 'package:aura/network/response.dart';
import 'package:aura/providers/location_provider.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/street_name_text.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class LocationItem extends StatefulWidget {
  final bool active;
  final LocationData data;
  final VoidCallback onSelect;

  const LocationItem({
    super.key,
    required this.data,
    this.active = false,
    required this.onSelect,
  });

  @override
  State<LocationItem> createState() => _LocationItemState();
}

class _LocationItemState extends State<LocationItem> {
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      final Color? background = !widget.active
          ? theme.cardBackground
          : isDark
              ? AppColors.secondary.withOpacity(0.15)
              : AppColors.primary.shade600.withOpacity(0.15);
      final Color? color = widget.active
          ? isDark
              ? AppColors.secondary
              : AppColors.primary.shade600
          : theme.paragraphDeep;
      final Color? cityNameColor = widget.active ? color : theme.paragraph;

      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: ClipSmoothRect(
          radius: SmoothBorderRadius(cornerRadius: 20, cornerSmoothing: 0),
          child: InkWell(
            onTap: widget.onSelect,
            borderRadius:
                SmoothBorderRadius(cornerRadius: 20, cornerSmoothing: 0),
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.4),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              color: background,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: background,
                      child: Icon(IconlyBold.location, color: color),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.data.name ?? "* No name provided *",
                          style: TextStyle(color: color),
                        ),
                        Wrap(
                          spacing: 20,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _generateCityName(cityNameColor),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Wrap(
                                spacing: 5,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(Iconsax.routing_2,
                                      size: 15,
                                      color: cityNameColor?.withOpacity(0.5)),
                                  Builder(builder: (context) {
                                    final position =
                                        Provider.of<LocationProvider>(context)
                                            .userPosition;

                                    return Text(
                                      CommonUtils.haversineDistance(
                                        widget.data.coordinates!,
                                        Coordinates(
                                            latitude: position?.latitude,
                                            longitude: position?.longitude),
                                      ).toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              cityNameColor?.withOpacity(0.5)),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _generateCityName(Color? color) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: StreetNameText(
        coords: widget.data.coordinates!,
        style: TextStyle(
          color: color?.withOpacity(0.5),
          fontSize: 12,
        ),
      ),
    );
  }
}
