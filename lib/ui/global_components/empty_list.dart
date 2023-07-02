import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/app_text_button.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

class EmptyList extends StatelessWidget {
  final bool disabled;
  final String message;
  final String? customSvg;
  final ImageProvider<Object>? customImage;
  final VoidCallback? onReload;

  const EmptyList({
    super.key,
    this.onReload,
    this.customSvg,
    this.customImage,
    required this.disabled,
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
                opacity: 0.2,
                child: Image(
                  width: 100,
                  image: customImage!,
                ),
              ),
            if (customImage == null && customSvg == null)
              Icon(EvaIcons.search, color: theme.paragraph),
            Text(
              message,
              style: TextStyle(fontSize: 16, color: theme.paragraph),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: AppTextButton(
                text: "Reload",
                disabled: disabled,
                onTap: onReload,
                icon: Iconsax.refresh,
              ),
            )
          ],
        ),
      );
    });
  }
}
