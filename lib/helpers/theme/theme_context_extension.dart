import 'package:aura/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension ThemeContextExtension on BuildContext {
  ThemeData get theme => watch<ThemeProvider>().currentTheme;
}
