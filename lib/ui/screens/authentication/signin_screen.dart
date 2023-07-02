// ignore_for_file: use_build_context_synchronously

import 'package:aura/helpers/navigation.dart';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/helpers/utils/prompt_util.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/services/firebase/auth_service.dart';
import 'package:aura/ui/global_components/app_button.dart';
import 'package:aura/ui/global_components/app_divider.dart';
import 'package:aura/ui/global_components/app_prompt/app_prompt_model.dart';
import 'package:aura/ui/global_components/app_text_field.dart';
import 'package:aura/ui/screens/home_screen/data/home_screen_data.dart';
import 'package:aura/ui/global_components/app_third_party_auth_buttons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:aura/ui/global_components/app_header.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:iconsax/iconsax.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleSubmit() async {
    final email = _emailController.value.text;
    final password = _passwordController.value.text;

    final (_, error) = await CommonUtils.callLoader(
      context,
      () => AuthService.signInUser(
        email: email,
        password: password,
      ),
      message: "Signing in to account...",
    );

    if (error != null) {
      return PromptUtil.show(
        context,
        PromptMessage(
          message: error,
          type: PromptType.error,
          title: "Sign in failed",
        ),
      );
    }

    Navigation.openHomeScreen(
      context,
      const NavigationParams(replace: true, argument: HomeScreenPage.profile),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyBuilder: (theme, isDark) {
        return Column(
          children: [
            const SafeArea(
              bottom: false,
              child: AppHeader(title: ""),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Text(
                        "Sign in to\nyour account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 35,
                          color: theme.heading,
                          fontWeight: FontWeight.w500,
                          // fontFamily: AppFonts.gilroyFont,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                              vertical: 50, horizontal: 20)
                          .copyWith(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppTextField(
                            icon: Iconsax.sms,
                            controller: _emailController,
                            placeholder: "Email Address",
                            type: TextInputType.emailAddress,
                          ),
                          AppTextField(
                            placeholder: "Password",
                            icon: Iconsax.password_check,
                            controller: _passwordController,
                            type: TextInputType.visiblePassword,
                          ),
                          const SizedBox(height: 30),
                          AppButton(
                            text: "Sign In",
                            onTap: _handleSubmit,
                            margin: EdgeInsets.zero,
                            textColor: Colors.white,
                            background: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    const AppDivider(text: "Or continue with"),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [AppThirdPartyAuthButtons()],
                    )
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: RichText(
                  text: TextSpan(
                    text: "Not a member? ",
                    style: TextStyle(
                      fontSize: 15,
                      color: theme.paragraph,
                      fontFamily: AppFonts.lufgaFont,
                    ),
                    children: [
                      TextSpan(
                        text: "Register now",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigation.openSignUpScreen(
                                context, const NavigationParams(replace: true));
                          },
                        style: TextStyle(
                          color:
                              isDark ? AppColors.secondary : AppColors.primary,
                          fontWeight: FontWeight.bold,
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
