import 'package:aura/resources/app_strings.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class CarouselPagination {
  final int page;
  final int total;

  CarouselPagination({required this.page, required this.total});
}

class CarouselHeader extends StatelessWidget {
  final bool showPagination;
  final CarouselPagination? pagination;
  const CarouselHeader(
      {super.key, this.showPagination = false, this.pagination});

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      builder: (theme, isDark) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select Country",
                style: TextStyle(
                  fontSize: 18,
                  color: theme.paragraphDeep,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.lufgaFont,
                ),
              ),
              if (showPagination)
                ClipSmoothRect(
                  radius: SmoothBorderRadius(cornerRadius: 20),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    color: theme.cardBackground,
                    child: Text(
                      "${pagination?.page} / ${pagination?.total}",
                      style: TextStyle(fontSize: 14, color: theme.paragraph),
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
