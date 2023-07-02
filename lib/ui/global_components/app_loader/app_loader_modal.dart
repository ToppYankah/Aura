import 'dart:ui';

import 'package:aura/ui/global_components/app_loader/app_loader.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class AppLoaderModal extends StatelessWidget {
  final String? message;
  const AppLoaderModal({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              const Positioned.fill(
                child: Material(color: Colors.black54),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ThemeBuilder(
                    builder: (theme, isDark) {
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white10
                                        : Colors.white.withOpacity(0.9),
                                    borderRadius: const SmoothBorderRadius.all(
                                      SmoothRadius(
                                          cornerRadius: 30,
                                          cornerSmoothing: 0.8),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 30),
                            child: Wrap(
                              spacing: 20,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const AppLoader(size: 25),
                                Text(
                                  message ?? "Please wait...",
                                  style: theme.styles!.paragraph.copyWith(
                                    color: theme.paragraph,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
