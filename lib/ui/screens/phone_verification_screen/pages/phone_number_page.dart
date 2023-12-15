// ignore_for_file: use_build_context_synchronously

import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/helpers/utils/prompt_util.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/services/firebase/auth_service.dart';
import 'package:aura/ui/global_components/app_prompt/app_prompt_model.dart';
import 'package:aura/ui/global_components/app_text_button.dart';
import 'package:aura/ui/global_components/app_text_field.dart';
import 'package:aura/ui/screens/phone_verification_screen/models/phone_verification_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class PhoneNumberPage extends StatefulWidget {
  final Function(PhoneVerificationDetail verificationDetail) onCodeSent;
  const PhoneNumberPage({super.key, required this.onCodeSent});

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<bool> _sendingCode = ValueNotifier<bool>(false);
  final ValueNotifier<String> _phoneNumber = ValueNotifier<String>("");

  @override
  void dispose() {
    _controller.dispose();
    _phoneNumber.dispose();
    _sendingCode.dispose();
    super.dispose();
  }

  void _handlePhoneVerification() async {
    final String phone = _phoneNumber.value;
    final bool isPhone = AppRegex.phone.hasMatch(phone);

    print("Phone to Verify: $phone");

    if (isPhone) {
      _sendingCode.value = true;
      return CommonUtils.callLoader(
        context,
        () => AuthService.verifyPhoneNumber(
          phone,
          onCodeSent: _handleCodeSent,
          onFailed: _handleVerificationFailure,
          onComplete: _handleVerificationComplete,
          codeRetrievalTimeout: _handleCodeRetrievalTimeout,
        ),
      );
    }

    PromptUtil.show(
      context,
      const PromptMessage(
        type: PromptType.error,
        title: "Invalid Phone Number",
        message: "Please enter a valid phone number to proceed.",
      ),
    );
  }

  void _handleCodeSent(String verificationId, int? token) async {
    _sendingCode.value = false;
    widget.onCodeSent(
        PhoneVerificationDetail(phone: _phoneNumber.value, id: verificationId));
  }

  void _handleCodeRetrievalTimeout(String value) async {
    _sendingCode.value = false;
    PromptUtil.show(
      context,
      PromptMessage(
        message: value,
        type: PromptType.error,
        title: "Retrieval Timeout",
      ),
    );
  }

  void _handleVerificationComplete(PhoneAuthCredential credential) async {
    _sendingCode.value = false;

    final (success: success, error: error) =
        await AuthService.verifyPhoneCredential(credential);

    if (!success) {
      return PromptUtil.show(
        context,
        PromptMessage(
          message: error!,
          type: PromptType.error,
          title: "Verification Failed",
        ),
      );
    }
  }

  void _handleVerificationFailure(FirebaseAuthException exception) async {
    _sendingCode.value = false;
    print("verification failed: ${exception.message}");

    PromptUtil.show(
      context,
      PromptMessage(
        type: PromptType.error,
        title: "Verification Failed",
        message: exception.message ?? "",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "Enter your phone number\nto receive a verification code.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 40),
          AppTextField(
            controller: _controller,
            type: TextInputType.phone,
            icon: Iconsax.call_calling,
            placeholder: "Phone Number",
            hint: "Eg: (+233) 593 000 000",
            onChange: (String value) => _phoneNumber.value = value,
          ),
          const SizedBox(height: 30),
          ValueListenableBuilder(
            valueListenable: _sendingCode,
            builder: (context, sending, _) {
              return AppTextButton(
                paddingSpace: 25,
                disabled: sending,
                enableBackground: true,
                icon: Iconsax.arrow_right_2,
                text: "Send Verification Code",
                onTap: _handlePhoneVerification,
                iconPosition: IconPosition.after,
              );
            },
          )
        ],
      ),
    );
  }
}
