import 'package:aura/ui/global_components/app_header.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyBuilder: (theme, isDark) {
        return const Column(
          children: [
            SafeArea(
              bottom: false,
              child: AppHeader(title: "About"),
            ),
          ],
        );
      },
    );
  }
}
