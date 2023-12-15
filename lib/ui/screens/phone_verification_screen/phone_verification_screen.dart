// ignore_for_file: use_build_context_synchronously

import 'package:aura/helpers/navigation.dart';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/helpers/utils/prompt_util.dart';
import 'package:aura/services/firebase/auth_service.dart';
import 'package:aura/ui/global_components/app_header.dart';
import 'package:aura/ui/global_components/app_prompt/app_prompt_model.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:aura/ui/global_components/app_slide_button.dart';
import 'package:aura/ui/screens/home_screen/data/home_screen_data.dart';
import 'package:aura/ui/screens/phone_verification_screen/models/phone_verification_detail.dart';
import 'package:aura/ui/screens/phone_verification_screen/pages/code_verification_page.dart';
import 'package:aura/ui/screens/phone_verification_screen/pages/phone_number_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final PageController _pageController = PageController();
  final ValueNotifier<String?> _code = ValueNotifier<String?>(null);
  final ValueNotifier<double> _currentPage = ValueNotifier<double>(0);
  final ValueNotifier<bool> _readyChecker = ValueNotifier<bool>(false);
  final ValueNotifier<PhoneVerificationDetail> _verificationDetail =
      ValueNotifier<PhoneVerificationDetail>(const PhoneVerificationDetail());

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      _currentPage.value = _pageController.page ?? 0;
    });
  }

  void _handleCodeSent(PhoneVerificationDetail verificationDetail) {
    _verificationDetail.value = verificationDetail;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutExpo,
    );
  }

  void _handleGoBack() => _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutExpo,
      );

  void _handleCodeReady(String? code) {
    _code.value = code;
    _readyChecker.value = code != null;
  }

  void _handleSubmit() async {
    final ({String? error, bool success})? response =
        await CommonUtils.callLoader<({String? error, bool success})>(
      context,
      () => AuthService.verifyPhoneCredential(
        PhoneAuthProvider.credential(
          smsCode: _code.value ?? "",
          verificationId: _verificationDetail.value.id,
        ),
      ),
    );

    if (response != null) {
      if (response.success) return _handleVerificationSuccess();

      PromptUtil.show(
        context,
        PromptMessage(
          type: PromptType.error,
          message: response.error!,
          title: "Verification Failed",
        ),
      );
    }
  }

  void _handleVerificationSuccess() {
    Navigation.openHomeScreen(
      context,
      const NavigationParams(
        replace: true,
        argument: HomeScreenPage.profile,
      ),
    );
    PromptUtil.show(
      context,
      const PromptMessage(
        type: PromptType.success,
        title: "Verification Successful",
        message:
            "Your phone number has been verified and updated successfully.",
      ),
    );
  }

  @override
  void dispose() {
    _verificationDetail.dispose();
    _readyChecker.dispose();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyBuilder: (theme, isDark) {
        return Column(
          children: [
            const SafeArea(bottom: false, child: AppHeader()),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  PhoneNumberPage(onCodeSent: _handleCodeSent),
                  ValueListenableBuilder(
                    valueListenable: _verificationDetail,
                    builder: (context, verificationDetail, _) {
                      return CodeVerificationPage(
                        onCodeReady: _handleCodeReady,
                        onChangePhone: _handleGoBack,
                        verificationDetail: verificationDetail,
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: ValueListenableBuilder(
                valueListenable: _readyChecker,
                builder: (context, ready, _) {
                  return SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: AppSlideButton(
                        buttonRadius: 30,
                        disabled: !ready,
                        submitText: "verify",
                        onSubmit: _handleSubmit,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
