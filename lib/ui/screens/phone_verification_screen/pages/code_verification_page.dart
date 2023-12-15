// ignore_for_file: use_build_context_synchronously

import 'package:aura/helpers/navigation.dart';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/helpers/utils/prompt_util.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/services/firebase/auth_service.dart';
import 'package:aura/ui/global_components/app_prompt/app_prompt_model.dart';
import 'package:aura/ui/global_components/app_slide_button.dart';
import 'package:aura/ui/global_components/app_text_button.dart';
import 'package:aura/ui/global_components/app_text_field.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/phone_verification_screen/models/phone_verification_detail.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CodeVerificationPage extends StatefulWidget {
  final VoidCallback onChangePhone;
  final Function(String?) onCodeReady;
  final PhoneVerificationDetail verificationDetail;

  const CodeVerificationPage({
    super.key,
    required this.onCodeReady,
    required this.onChangePhone,
    required this.verificationDetail,
  });

  @override
  State<CodeVerificationPage> createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  final int _codeMaxLength = 6;
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<String> _value = ValueNotifier<String>("");
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    CommonUtils.performPostBuild(context, () {
      _focusNode.requestFocus();
    });

    _codeController.addListener(() {
      _value.value = _codeController.text;

      if (_codeController.text.length == _codeMaxLength) {
        widget.onCodeReady(_codeController.value.text);
      } else {
        widget.onCodeReady(null);
      }
    });
  }

  void _handleGoBack() {
    _codeController.clear();
    widget.onChangePhone();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _value.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "Code Verification",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          ThemeBuilder(builder: (theme, isDark) {
            return Stack(
              children: [
                Positioned(
                  child: Opacity(
                    opacity: 0,
                    child: AppTextField(
                      focusNode: _focusNode,
                      maxLength: _codeMaxLength,
                      controller: _codeController,
                      type: const TextInputType.numberWithOptions(),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "An OTP code has been sent to ",
                          style: const TextStyle(
                            height: 1.5,
                            fontSize: 16,
                            fontFamily: AppFonts.lufgaFont,
                          ),
                          children: [
                            TextSpan(
                              text: widget.verificationDetail.phone,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.secondary
                                    : AppColors.primary,
                              ),
                            ),
                            const TextSpan(
                              text: ". Enter the code in the field below.",
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    LayoutBuilder(builder: (context, constraints) {
                      return Wrap(
                        spacing: 5,
                        children: [
                          for (int i = 0; i < 6; i++)
                            ValueListenableBuilder(
                              valueListenable: _value,
                              builder: (context, text, _) {
                                final isActive = i == text.length;
                                final bool hasValue = text.length >= i + 1;
                                final width = constraints.maxWidth / 6.5;
                                final color = isDark
                                    ? Colors.white24
                                    : theme.cardBackground;

                                final borderColor = isDark
                                    ? AppColors.secondary
                                    : AppColors.secondary;

                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _focusNode.requestFocus,
                                    borderRadius: SmoothBorderRadius(
                                      cornerRadius: 15,
                                      cornerSmoothing: 0.8,
                                    ),
                                    child: Container(
                                      height: width,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: SmoothBorderRadius(
                                          cornerRadius: 15,
                                          cornerSmoothing: 0.8,
                                        ),
                                        border: isActive
                                            ? Border.all(
                                                width: 2, color: borderColor)
                                            : Border.all(
                                                width: 0,
                                                color: Colors.transparent),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        hasValue ? text[i] : "",
                                        style: const TextStyle(
                                          height: 0,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                        ],
                      );
                    }),
                    const SizedBox(height: 30),
                    AppTextButton(
                      paddingSpace: 20,
                      onTap: _handleGoBack,
                      enableBackground: true,
                      textWeight: FontWeight.w300,
                      text: "Use a different phone number",
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
