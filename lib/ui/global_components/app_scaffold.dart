import 'package:aura/helpers/theme/extensions/theme_extension.dart';
import 'package:aura/providers/theme_provider.dart';
import 'package:flutter/material.dart';

typedef ThemeFunction = Widget? Function(AppTheme theme, bool isDark);

class AppScaffold extends StatelessWidget {
  final ThemeFunction? bodyBuilder;
  final Future<bool> Function()? onWillPop;
  const AppScaffold({super.key, this.bodyBuilder, this.onWillPop});

  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = context.theme.extension<AppTheme>()!;
    final bool isDark = context.theme.brightness == Brightness.dark;
    final Widget? body =
        bodyBuilder != null ? bodyBuilder!(appTheme, isDark) : null;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(backgroundColor: appTheme.background, body: body),
    );
  }
}
