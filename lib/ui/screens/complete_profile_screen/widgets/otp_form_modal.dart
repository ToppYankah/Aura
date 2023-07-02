import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:aura/ui/global_components/app_slide_button.dart';
import 'package:aura/ui/global_components/app_text_field.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class OTPCodeForm extends StatefulWidget {
  final String phone;
  final Function onClose;
  final Function(String) onDone;

  const OTPCodeForm({
    super.key,
    required this.phone,
    required this.onDone,
    required this.onClose,
  });

  @override
  State<OTPCodeForm> createState() => _OTPCodeFormState();
}

class _OTPCodeFormState extends State<OTPCodeForm> {
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<String> _value = ValueNotifier<String>("");
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    CommonUtils.performPostBuild(context, () {
      _focusNode.requestFocus();
    });

    _codeController.addListener(() => _value.value = _codeController.text);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    _value.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      return Stack(
        children: [
          Positioned(
            child: Opacity(
              opacity: 0,
              child: AppTextField(
                focusNode: _focusNode,
                type: TextInputType.number,
                controller: _codeController,
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
                      fontSize: 18,
                      fontFamily: AppFonts.lufgaFont,
                    ),
                    children: [
                      TextSpan(
                        text: widget.phone,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color:
                              isDark ? AppColors.secondary : AppColors.primary,
                        ),
                      ),
                      const TextSpan(
                          text: ". Enter the code in the field below."),
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
                          final color =
                              isDark ? Colors.white24 : Colors.black26;
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
                                      ? Border.all(width: 2, color: borderColor)
                                      : Border.all(width: 0),
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
              const SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: AppSlideButton(
                  disabled: true,
                  onSubmit: () {},
                  buttonRadius: 25,
                  submitText: "verify",
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
