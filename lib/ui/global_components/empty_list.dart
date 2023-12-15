import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/app_text_button.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

class AppEmptyPlaceholder extends StatelessWidget {
  final bool disabled;
  final String message;
  final IconData? icon;
  final String? customSvg;
  final VoidCallback? onReload;
  final ImageProvider<Object>? customImage;

  const AppEmptyPlaceholder({
    super.key,
    this.icon,
    this.onReload,
    this.customSvg,
    this.customImage,
    this.disabled = false,
    this.message = "List is empty",
  });

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      return Container(
        alignment: Alignment.center,
        child: Wrap(
          spacing: 10,
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (customSvg != null)
              Opacity(
                opacity: 0.2,
                child: SvgPicture.asset(
                  customSvg!,
                  width: 100,
                  color: isDark ? Colors.white : AppColors.primary,
                ),
              ),
            if (customImage != null)
              Opacity(
                opacity: isDark ? 0.3 : 0.5,
                child: Image(
                  width: 100,
                  image: customImage!,
                ),
              ),
            if (customImage == null && customSvg == null)
              Icon(icon ?? EvaIcons.search, color: theme.paragraph),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: theme.paragraph),
            ),
            if (onReload != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: AppTextButton(
                  text: "Reload",
                  onTap: onReload,
                  disabled: disabled,
                  icon: Iconsax.refresh,
                  enableBackground: true,
                ),
              )
          ],
        ),
      );
    });
  }
}
