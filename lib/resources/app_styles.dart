import 'package:flutter/material.dart';

abstract class ThemeStyles {
  final TextStyle hugeText;
  final TextStyle paragraph;

  const ThemeStyles({required this.hugeText, required this.paragraph});
}
