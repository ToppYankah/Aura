import 'dart:ui';

import 'package:aura/network/api/locations/models/location_parameter.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

class PollutantSelectorItem extends StatelessWidget {
  final bool active;
  final LocationParameter data;
  final VoidCallback onSelect;

  const PollutantSelectorItem({
    super.key,
    required this.data,
    this.active = false,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = !active ? Colors.white10 : AppColors.secondary;

    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: InkWell(
        onTap: onSelect,
        splashColor: AppColors.secondary.withOpacity(0.5),
        borderRadius:
            SmoothBorderRadius(cornerRadius: 20, cornerSmoothing: 0.8),
        child: ClipSmoothRect(
          radius: SmoothBorderRadius(
            cornerRadius: 20,
            cornerSmoothing: 0.8,
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AnimatedContainer(
              color: backgroundColor,
              duration: const Duration(milliseconds: 300),
              constraints: const BoxConstraints(minWidth: 70),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [
                  // if (data.icon != null)
                  //   SvgPicture.asset(
                  //     data.icon!,
                  //     width: 20,
                  //     color: Colors.white,
                  //   ),

                  Text(
                    (data.parameter ?? "").toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Icon(
                    EvaIcons.checkmarkCircle2,
                    size: 18,
                    color: active ? Colors.white : Colors.white10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
