// ignore_for_file: use_build_context_synchronously

import 'package:aura/helpers/navigation.dart';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/helpers/utils/prompt_util.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/services/firebase/auth_service.dart';
import 'package:aura/ui/global_components/app_button.dart';
import 'package:aura/ui/global_components/app_divider.dart';
import 'package:aura/ui/global_components/app_header.dart';
import 'package:aura/ui/global_components/app_prompt/app_prompt_model.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:aura/ui/global_components/app_text_field.dart';
import 'package:aura/ui/screens/home_screen/data/home_screen_data.dart';
import 'package:aura/ui/global_components/app_third_party_auth_buttons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _handleRegister() async {
    final email = _emailController.value.text;
    final username = _usernameController.value.text;
    final password = _passwordController.value.text;
    final confirmPassword = _confirmPasswordController.value.text;

    final (_, error) = await CommonUtils.callLoader(
      context,
      () => AuthService.registerUser(
        email: email,
        username: username,
        password: password,
        confirmPassword: confirmPassword,
      ),
      message: "Registering your account...",
    );

    if (error != null) {
      return PromptUtil.show(
        context,
        PromptMessage(
          title: "Registration failed",
          message: error,
          type: PromptType.error,
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
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
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
                        "Register a free\naccount",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          color: theme.heading,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.gilroyFont,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppThirdPartyAuthButtons(),
                            ],
                          ),
                          const AppDivider(text: "Or continue with", space: 30),
                          AppTextField(
                            icon: Iconsax.user,
                            placeholder: "Username",
                            controller: _usernameController,
                            type: TextInputType.emailAddress,
                          ),
                          AppTextField(
                            icon: Iconsax.sms,
                            controller: _emailController,
                            placeholder: "Email Address",
                            type: TextInputType.emailAddress,
                          ),
                          AppTextField(
                            icon: Iconsax.password_check,
                            placeholder: "Choose Password",
                            controller: _passwordController,
                            type: TextInputType.visiblePassword,
                            hint: "Should have atleast 8 characters",
                          ),
                          AppTextField(
                            icon: Iconsax.password_check,
                            placeholder: "Confirm Password",
                            type: TextInputType.visiblePassword,
                            controller: _confirmPasswordController,
                          ),
                          const SizedBox(height: 30),
                          AppButton(
                            text: "Register",
                            onTap: _handleRegister,
                            textColor: Colors.white,
                            background: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
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
                    text: "Already a member? ",
                    style: TextStyle(
                      fontSize: 15,
                      color: theme.paragraph,
                      fontFamily: AppFonts.lufgaFont,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign in here",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigation.openSignInScreen(
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
