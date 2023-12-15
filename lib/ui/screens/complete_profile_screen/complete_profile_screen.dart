// ignore_for_file: use_build_context_synchronously

import 'package:aura/helpers/navigation.dart';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/helpers/utils/prompt_util.dart';
import 'package:aura/services/firebase/auth_service.dart';
import 'package:aura/ui/global_components/app_header.dart';
import 'package:aura/ui/global_components/app_prompt/app_prompt_model.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:aura/ui/global_components/app_slide_button.dart';
import 'package:aura/ui/global_components/app_text_field.dart';
import 'package:aura/ui/screens/home_screen/data/home_screen_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:iconsax/iconsax.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  late final bool _emailDisabled, _usernameDisabled, _phoneNumberDisabled;
  late final TextEditingController _emailController,
      _usernameController,
      _phoneNumberController;

  @override
  void initState() {
    super.initState();
    final user = AuthService.user;

    // Set Disabled fields
    _emailDisabled = user?.email != null && user!.email!.isNotEmpty;
    _usernameDisabled =
        user?.displayName != null && user!.displayName!.isNotEmpty;
    _phoneNumberDisabled =
        user?.phoneNumber != null && user!.phoneNumber!.isNotEmpty;

    // Prefill textfields with values
    _emailController =
        TextEditingController(text: _emailDisabled ? user!.email : "");
    _usernameController =
        TextEditingController(text: _usernameDisabled ? user!.displayName : "");
    _phoneNumberController = TextEditingController(
        text: _phoneNumberDisabled
            ? user!.phoneNumber!.substring(user.phoneNumber!.length - 9)
            : "");

    _emailController.addListener(() => setState(() {}));
    _usernameController.addListener(() => setState(() {}));
    _phoneNumberController.addListener(() => setState(() {}));
  }

  void _handleSubmitProfile() async {
    final String? response = await CommonUtils.callLoader(
      context,
      () async => await AuthService.completeProfile(),
      onError: () => PromptUtil.show(
        context,
        const PromptMessage(
            type: PromptType.error,
            title: "Failed to Complete",
            message: "Something went wrong. Please try again."),
      ),
    );

    if (response != null) {
      return PromptUtil.show(
        context,
        PromptMessage(
          message: response,
          type: PromptType.error,
          title: "Failed to Complete",
        ),
      );
    }

    Navigation.openHomeScreen(
      context,
      const NavigationParams(argument: HomeScreenPage.profile, replace: true),
    );
  }

  bool _readyForSubmittion() =>
      _usernameController.text.isNotEmpty && _emailController.text.isNotEmpty;

  @override
  void dispose() {
    _phoneNumberController.dispose();
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
            SafeArea(
              bottom: false,
              child: AppHeader(
                // title: "Complete Profile",
                onBack: () async => await AuthService.signOut(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Kindly complete your\nprofile 📝",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      // "These details help us to easily identify you\nfor your security.",
                      "Your profile is incomplete. Add the missing information to enjoy a fully optimized experience.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: theme.paragraph),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppTextField(
                            icon: Iconsax.user_edit,
                            placeholder: "Username",
                            type: TextInputType.name,
                            disabled: _usernameDisabled,
                            controller: _usernameController,
                          ),
                          AppTextField(
                            icon: Iconsax.sms_edit,
                            disabled: _emailDisabled,
                            controller: _emailController,
                            placeholder: "Email Address",
                            type: TextInputType.emailAddress,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            KeyboardVisibilityBuilder(
              builder: (context, isVisible) {
                return isVisible
                    ? const SizedBox()
                    : Padding(
                        padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.12)
                            .copyWith(bottom: 10),
                        child: SafeArea(
                          top: false,
                          child: AppSlideButton(
                            buttonRadius: 30,
                            submitText: "complete",
                            onSubmit: _handleSubmitProfile,
                            disabled: !_readyForSubmittion(),
                          ),
                        ),
                      );
              },
            )
          ],
        );
      },
    );
  }
}
