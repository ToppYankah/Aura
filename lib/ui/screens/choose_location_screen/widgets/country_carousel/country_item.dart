import 'package:aura/resources/app_colors.dart';
import 'package:dash_flags/dash_flags.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class CountryItem extends StatelessWidget {
  final String? countryCode;
  const CountryItem({super.key, this.countryCode});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      final width = constraint.maxWidth * .6;
      return CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.primary.withOpacity(0.2),
        child: ClipSmoothRect(
          radius: SmoothBorderRadius(
            cornerRadius: 100,
            cornerSmoothing: 0,
          ),
          child: Transform.translate(
            offset: const Offset(0, 0),
            child: Transform.scale(
              scaleX: 1.5,
              child: SizedBox(
                width: width,
                height: width,
                child: CountryFlag(
                  country: Country.fromCode(countryCode ?? ""),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
