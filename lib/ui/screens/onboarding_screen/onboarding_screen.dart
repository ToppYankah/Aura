import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aura/helpers/navigation.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/app_button.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:aura/ui/screens/onboarding_screen/widgets/skip_button.dart';
import 'package:aura/ui/screens/onboarding_screen/widgets/curve_clipper.dart';
import 'package:aura/ui/screens/onboarding_screen/widgets/onboarding_info.dart';
import 'package:aura/ui/screens/onboarding_screen/data/onboarding_screen_data.dart';
import 'package:aura/ui/screens/onboarding_screen/widgets/pagination_indicator.dart';
import 'package:aura/ui/global_components/app_third_party_auth_buttons.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Timer? _timer;
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _runTimer();
  }

  void _runTimer() {
    if (!mounted) return;
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_pageController.page! < 2) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _pageController.animateToPage(0,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void _handlePageChanged(int index) => setState(() => _currentIndex = index);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyBuilder: (theme, isDark) => Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ClipPath(
                  clipper: CurveClipper(),
                  child: Container(
                    color: AppColors.primary.withOpacity(0.2),
                    child: GestureDetector(
                      onTapUp: (_) => _runTimer(),
                      onTapDown: (_) => _timer?.cancel(),
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: _handlePageChanged,
                        physics: const BouncingScrollPhysics(),
                        itemCount: OnboardingScreenData.data.length,
                        itemBuilder: (context, index) {
                          return OnboardingScreenData.data[index].image;
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25)
                    .copyWith(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OnboardingInfoSection(index: _currentIndex),
                    PaginationIndicator(index: _currentIndex),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              textSize: 18,
                              text: "Sign In",
                              textColor: Colors.white,
                              background: AppColors.primary,
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              onTap: () => Navigation.openSignInScreen(context),
                            ),
                          ),
                          const AppThirdPartyAuthButtons(showNames: false),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          const SkipButton(),
        ],
      ),
    );
  }
}
