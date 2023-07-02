import 'package:aura/resources/app_colors.dart';
import 'package:aura/resources/app_images.dart';
import 'package:aura/ui/global_components/app_header.dart';
import 'package:aura/ui/global_components/app_icon_button.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:aura/ui/global_components/section_card.dart';
import 'package:aura/ui/screens/health_tips_screen/data/health_tips_data.dart';
import 'package:aura/ui/screens/health_tips_screen/widgets/tip_tab.dart';
import 'package:aura/ui/screens/health_tips_screen/widgets/tip_tile.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({super.key});

  @override
  State<HealthTipsScreen> createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> {
  int _currentTab = 0;
  final PageController _pageController = PageController();

  void _handlePageChanged(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const data = HealthTipsData.healthTips;
    bool canGoPrev = _currentTab > 0;
    bool canGoNext = _currentTab < data.length - 1;
    const Curve swipeCurve = Curves.easeOutExpo;
    const Duration swipeDuration = Duration(milliseconds: 500);

    return AppScaffold(
      bodyBuilder: (theme, isDark) {
        final Color controllerBgColor =
            isDark ? Colors.white12 : AppColors.primary.withOpacity(0.2);
        final Color controllerIconColor =
            isDark ? Colors.white : AppColors.primary;
        return Column(
          children: [
            const SafeArea(
                bottom: false, child: AppHeader(title: "Health Tips")),
            Expanded(
              child: SectionCard(
                margin: const EdgeInsets.only(bottom: 10),
                child: Expanded(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: IgnorePointer(
                          ignoring: true,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Transform.flip(
                              flipX: true,
                              child: Opacity(
                                opacity: 0.1,
                                child: Image(
                                  image: isDark
                                      ? AppImages.arrowDark
                                      : AppImages.arrowLight,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: PageView.builder(
                          itemCount: data.length,
                          controller: _pageController,
                          onPageChanged: _handlePageChanged,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) =>
                              TipTile(data: data[index]),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20),
                          child: Row(
                            children: data.map((e) {
                              final int index = data.indexOf(e);
                              final bool active = index == _currentTab;
                              final bool skipped = _currentTab > index;
                              return TipTab(
                                active: active,
                                skipped: skipped,
                                onComplete: () {
                                  if (_currentTab == index &&
                                      index < data.length - 1) {
                                    _pageController.nextPage(
                                      duration: swipeDuration,
                                      curve: swipeCurve,
                                    );
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IgnorePointer(
                                ignoring: !canGoPrev,
                                child: Opacity(
                                  opacity: canGoPrev ? 1 : 0,
                                  child: AppIconButton(
                                    radius: 35,
                                    iconSize: 35,
                                    icon: IconlyLight.arrow_left,
                                    background: controllerBgColor,
                                    iconColor: controllerIconColor,
                                    onTap: () => _pageController.previousPage(
                                        duration: swipeDuration,
                                        curve: swipeCurve),
                                  ),
                                ),
                              ),
                              IgnorePointer(
                                ignoring: !canGoNext,
                                child: Opacity(
                                  opacity: canGoNext ? 1 : 0,
                                  child: AppIconButton(
                                    iconSize: 35,
                                    radius: 35,
                                    icon: IconlyLight.arrow_right,
                                    background: controllerBgColor,
                                    iconColor: controllerIconColor,
                                    onTap: () => _pageController.nextPage(
                                        duration: swipeDuration,
                                        curve: swipeCurve),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
