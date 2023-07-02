import 'dart:ui';

import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/section_card_title.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

enum CardCorners { all, top, bottom }

class SectionCard extends StatelessWidget {
  final Widget? child;
  final Color? background;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final CardCorners corners;
  final SectionCardTitle? title;
  final bool useHorizontalSpace;
  final bool showInteractiveIndicator;

  const SectionCard({
    super.key,
    this.child,
    this.onTap,
    this.title,
    this.margin,
    this.background,
    this.corners = CardCorners.all,
    this.useHorizontalSpace = true,
    this.showInteractiveIndicator = true,
  });

  SmoothBorderRadius _getCardBorderRadius() {
    switch (corners) {
      case CardCorners.top:
        return const SmoothBorderRadius.vertical(
          top: SmoothRadius(
            cornerRadius: 40,
            cornerSmoothing: 0.8,
          ),
        );

      case CardCorners.bottom:
        return const SmoothBorderRadius.vertical(
          bottom: SmoothRadius(
            cornerRadius: 40,
            cornerSmoothing: 0.8,
          ),
        );
      default:
        return SmoothBorderRadius(
          cornerRadius: 40,
          cornerSmoothing: 0.8,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      return Container(
        margin: margin,
        padding: EdgeInsets.symmetric(horizontal: useHorizontalSpace ? 10 : 0),
        child: ClipSmoothRect(
          clipBehavior: Clip.hardEdge,
          radius: _getCardBorderRadius(),
          child: Container(
            color: background ?? theme.cardBackground,
            // constraints: const BoxConstraints(minHeight: 200),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                splashColor: AppColors.primary.shade300.withOpacity(0.1),
                highlightColor: AppColors.primary.shade300.withOpacity(0.1),
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 40,
                  cornerSmoothing: 0.8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: title ?? const SizedBox()),
                        if (onTap != null && showInteractiveIndicator)
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Transform.translate(
                              offset: const Offset(0, 5),
                              child: Wrap(
                                spacing: 5,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text("More",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: theme.paragraph)),
                                  Icon(EvaIcons.arrowForward,
                                      size: 15, color: theme.paragraph),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    // title ?? const SizedBox(),
                    child ?? const SizedBox(),
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
