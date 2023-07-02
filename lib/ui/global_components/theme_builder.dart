import 'package:aura/helpers/theme/extensions/theme_extension.dart';
import 'package:aura/providers/theme_provider.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:flutter/material.dart';

class ThemeBuilder extends StatelessWidget {
  final ThemeFunction builder;
  const ThemeBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = context.theme.extension<AppTheme>()!;
    final bool isDark = context.theme.brightness == Brightness.dark;

    return builder(appTheme, isDark)!;
  }
}
