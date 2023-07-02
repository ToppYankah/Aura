import 'package:aura/resources/app_colors.dart';
import 'package:aura/resources/app_svgs.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CarouselDisplay extends StatelessWidget {
  final bool loading;
  final String value;
  final String typeAhead;
  final String searchValue;
  final VoidCallback? onTap;

  const CarouselDisplay({
    super.key,
    this.onTap,
    required this.value,
    this.typeAhead = "",
    this.loading = false,
    this.searchValue = "",
  });

  @override
  Widget build(BuildContext context) {
    final String displayValue = searchValue.isEmpty ? value : searchValue;
    const TextStyle textStyle = TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: Transform.translate(
        offset: const Offset(0, 10),
        child: ThemeBuilder(builder: (theme, isDark) {
          final Color color = isDark ? Colors.white : AppColors.primary;
          return Wrap(
            spacing: 20,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SvgPicture.asset(AppSvgs.shortArrowsBack,
                  width: 25, color: color),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Stack(
                        children: [
                          Text(
                            searchValue.isEmpty ? "" : typeAhead,
                            style: textStyle.copyWith(color: Colors.white54),
                          ),
                          Text(
                            loading ? "Loading" : displayValue,
                            style: textStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SvgPicture.asset(AppSvgs.shortArrows, width: 25, color: color),
            ],
          );
        }),
      ),
    );
  }
}
