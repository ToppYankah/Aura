import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/services/firebase/auth_service.dart';
import 'package:aura/ui/global_components/app_header.dart';
import 'package:aura/ui/global_components/app_modal/modal_model.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:aura/ui/global_components/app_slide_button.dart';
import 'package:aura/ui/global_components/app_text_button.dart';
import 'package:aura/ui/global_components/app_text_field.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/complete_profile_screen/widgets/otp_form_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:iconsax/iconsax.dart';
import 'package:regexed_validator/regexed_validator.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  PhoneAuthCredential? _phoneAuthCredential;
  final ValueNotifier<bool> _phoneVerifying = ValueNotifier<bool>(false);
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
    _emailController = TextEditingController(text: user?.email ?? "");
    _usernameController = TextEditingController(text: user?.displayName ?? "");
    _phoneNumberController =
        TextEditingController(text: user?.phoneNumber ?? "");

    _emailController.addListener(() => setState(() {}));
    _usernameController.addListener(() => setState(() {}));
    _phoneNumberController.addListener(() => setState(() {}));
  }

  void _handleSubmitProfile() async {
    await CommonUtils.callLoader(
      context,
      () async => await AuthService.completeProfile(),
    );
  }

  bool _readyForSubmittion() =>
      _usernameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _phoneAuthCredential != null;

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneVerifying.dispose();
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
                title: "Complete Profile",
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
                      "Kindly share\nthe following details\nwith us 📝",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "These details help us to easily identify you\nproperly for your security.",
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
                          PhoneNumberField(
                            disabled: _phoneNumberDisabled,
                            controller: _phoneNumberController,
                            onVerified: (credential) =>
                                _phoneAuthCredential = credential,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            KeyboardVisibilityBuilder(builder: (context, isVisible) {
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
            })
          ],
        );
      },
    );
  }
}

class PhoneNumberField extends StatefulWidget {
  final bool disabled;
  final TextEditingController? controller;
  final Function(PhoneAuthCredential) onVerified;

  const PhoneNumberField(
      {super.key,
      this.controller,
      this.disabled = false,
      required this.onVerified});

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  late final bool _phoneNumberDisabled;
  late final TextEditingController _phoneNumberController;
  final ValueNotifier<bool> _phoneVerifying = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    // Set Disabled fields
    _phoneNumberDisabled = widget.disabled;

    // Prefill textfields with values
    if (widget.controller != null) {
      _phoneNumberController = widget.controller!;
    } else {
      _phoneNumberController = TextEditingController();
    }

    _phoneNumberController.addListener(() => setState(() {}));
  }

  void _handlePhoneVerification() async {
    final String phone = _phoneNumberController.text;
    if (validator.phone(phone)) {
      _phoneVerifying.value = true;
      final formattedPhone = "+233${phone.replaceFirst(RegExp(r'0'), '')}";

      await AuthService.verifyPhoneNumber(
        formattedPhone,
        onCodeSent: _handleCodeSent,
        onFailed: _handleVerificationFailure,
        onComplete: _handleVerificationComplete,
        codeRetrievalTimeout: _handleCodeRetrievalTimeout,
      );
    }
  }

  void _handleCodeSent(String verificationId, int? token) async {
    CommonUtils.showModal(
      context,
      options: const ModalOptions(title: "Verify OTP"),
      child: (Function handleClose) => OTPCodeForm(
        onClose: handleClose,
        phone: _phoneNumberController.text,
        onDone: (String code) => _handleOtpComplete(
          PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: code),
        ),
      ),
    );
  }

  void _handleOtpComplete(PhoneAuthCredential code) {}

  void _handleCodeRetrievalTimeout(String value) async {
    print(value);
    _phoneVerifying.value = false;
  }

  void _handleVerificationComplete(PhoneAuthCredential credential) async {
    _phoneVerifying.value = false;
    widget.onVerified(credential);
  }

  void _handleVerificationFailure(FirebaseAuthException exception) async {
    print("verification failed");
    _phoneVerifying.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      return AppTextField(
        leading: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: AppTextButton(
            textSize: 16,
            text: "+233",
            onTap: () {},
            color: theme.heading,
            enableBackground: true,
            textWeight: FontWeight.w300,
          ),
        ),
        icon: Iconsax.call_calling,
        type: TextInputType.number,
        placeholder: "Phone Number",
        disabled: _phoneNumberDisabled,
        controller: _phoneNumberController,
        hint: "Please use a valid phone number",
        trailing: ValueListenableBuilder(
          valueListenable: _phoneVerifying,
          builder: (context, verifying, _) {
            final bool isPhone =
                AppRegex.phone.hasMatch(_phoneNumberController.text);

            return isPhone
                ? AppTextButton(
                    text: "Verify",
                    disabled: verifying,
                    enableBackground: true,
                    icon: Iconsax.arrow_right_1,
                    onTap: _handlePhoneVerification,
                    iconPosition: IconPosition.after,
                  )
                : const SizedBox();
          },
        ),
      );
    });
  }
}
