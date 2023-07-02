// ignore_for_file: use_build_context_synchronously

import 'package:aura/helpers/navigation.dart';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/helpers/utils/prompt_util.dart';
import 'package:aura/resources/app_svgs.dart';
import 'package:aura/services/firebase/auth_service.dart';
import 'package:aura/ui/global_components/app_prompt/app_prompt_model.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/home_screen/data/home_screen_data.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppThirdPartyAuthButtons extends StatefulWidget {
  final bool showNames;
  const AppThirdPartyAuthButtons({super.key, this.showNames = true});

  @override
  State<AppThirdPartyAuthButtons> createState() =>
      _AppThirdPartyAuthButtonsState();
}

class _AppThirdPartyAuthButtonsState extends State<AppThirdPartyAuthButtons> {
  void _callEror(String error) {
    if (error.isEmpty) return;
    PromptUtil.show(
      context,
      PromptMessage(
          title: "Attempt Failed", message: error, type: PromptType.error),
    );
  }

  void _callSuccess({bool profileIncomplete = false}) {
    if (profileIncomplete) {
      Navigation.openCompleteProfile(
          context, const NavigationParams(replace: true));
    } else {
      Navigation.openHomeScreen(
        context,
        const NavigationParams(replace: true, argument: HomeScreenPage.profile),
      );
    }
  }

  void _handleGoogleSignIn() async {
    final (success, error, profileIncomplete: profileIncomplete) =
        await CommonUtils.callLoader(context, AuthService.signInWithGoogle,
            message: "Initializing Google sign in...");

    if (error != null) return _callEror(error);
    if (success) _callSuccess(profileIncomplete: profileIncomplete);
  }

  void _handleAppleSignIn() async {
    final (success, error, profileIncomplete: profileIncomplete) =
        await CommonUtils.callLoader(context, AuthService.signInWithApple,
            message: "Initializing Apple sign in...");

    if (error != null) return _callEror(error);
    if (success) _callSuccess(profileIncomplete: profileIncomplete);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      return Wrap(
        spacing: 10,
        children: [
          ThirdPartyButton(
            image: AppSvgs.googleLogo,
            onTap: _handleGoogleSignIn,
            text: widget.showNames ? "Google" : "",
          ),
          ThirdPartyButton(
              image: AppSvgs.appleLogo,
              onTap: _handleAppleSignIn,
              text: widget.showNames ? "Apple" : "",
              useColor: true),
        ],
      );
    });
  }
}

class ThirdPartyButton extends StatelessWidget {
  final String text;
  final String image;
  final bool useColor;
  final VoidCallback onTap;
  const ThirdPartyButton({
    super.key,
    required this.image,
    this.useColor = false,
    this.text = "",
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      return Material(
        color: Colors.transparent,
        child: ClipSmoothRect(
          radius: SmoothBorderRadius(
            cornerRadius: 25,
            cornerSmoothing: 0.8,
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: SmoothBorderRadius(
              cornerRadius: 25,
              cornerSmoothing: 0.8,
            ),
            child: Container(
              height: 60,
              alignment: Alignment.center,
              color: theme.cardBackground,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SvgPicture.asset(
                    image,
                    width: 25,
                    color: useColor
                        ? isDark
                            ? Colors.white
                            : Colors.black
                        : null,
                  ),
                  if (text.isNotEmpty)
                    Text(
                      text,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
