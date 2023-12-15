import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/app_icon_button.dart';
import 'package:aura/ui/global_components/app_modal/modal_model.dart';
import 'package:aura/ui/global_components/app_text_button.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/complete_profile_screen/widgets/country_code_selector.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AppTextField extends StatefulWidget {
  final String? hint;
  final int? maxLines;
  final bool disabled;
  final int? maxLength;
  final IconData? icon;
  final double textSize;
  final Widget? leading;
  final bool applyMargin;
  final Widget? trailing;
  final bool applyPadding;
  final Color? background;
  final String placeholder;
  final TextInputType type;
  final FocusNode? focusNode;
  final IconData? disabledIcon;
  final double placeholderSize;
  final Function(String)? onChange;
  final TextEditingController? controller;

  const AppTextField({
    super.key,
    this.icon,
    this.hint,
    this.leading,
    this.trailing,
    this.onChange,
    this.maxLines,
    this.focusNode,
    this.maxLength,
    this.controller,
    this.background,
    this.textSize = 17,
    this.disabled = false,
    this.applyMargin = true,
    this.applyPadding = true,
    this.placeholderSize = 14,
    this.type = TextInputType.text,
    this.disabledIcon = Iconsax.lock,
    this.placeholder = "Input Label",
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  Widget? _leading;
  bool _showPassword = false;
  FocusNode _focusNode = FocusNode();
  final ValueNotifier<String> _callCode = ValueNotifier<String>("+233");

  @override
  void initState() {
    super.initState();

    if (widget.focusNode != null) _focusNode = widget.focusNode!;

    if (widget.type == TextInputType.phone && widget.leading == null) {
      _setInputLeading();
    }
  }

  void _setInputLeading() {
    _leading = Padding(
      padding: const EdgeInsets.only(right: 5),
      child: ValueListenableBuilder(
        valueListenable: _callCode,
        builder: (context, code, _) {
          return ThemeBuilder(builder: (theme, _) {
            return AppTextButton(
              text: code,
              textSize: 16,
              color: theme.heading,
              enableBackground: true,
              textWeight: FontWeight.w300,
              onTap: _handleSelectCallCode,
            );
          });
        },
      ),
    );
  }

  void _handleSelectCallCode() {
    CommonUtils.showModal(
      context,
      child: (onClose) => CountryCallCodeSelector(
        onClose: onClose,
        selected: _callCode.value,
        onSelect: (String code) => _callCode.value = code,
      ),
      options: const ModalOptions(title: "Select country code"),
    );
  }

  void _handleValueChanged(String value) {
    String output;

    switch (widget.type) {
      case TextInputType.phone:
        output = _callCode.value + value.replaceFirst(RegExp(r'^0'), '');
        break;
      default:
        output = value;
    }

    (widget.onChange ?? (String val) {})(output);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasIcon = widget.icon != null;
    final bool hasLeading = _leading != null;
    final obscureText = widget.type == TextInputType.visiblePassword;

    return ThemeBuilder(
      builder: (theme, isDark) {
        return Padding(
          padding: EdgeInsets.only(bottom: widget.applyMargin ? 20 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Opacity(
                opacity: widget.disabled ? 0.4 : 1,
                child: Container(
                  padding: EdgeInsets.symmetric(
                          vertical: widget.applyPadding ? 5 : 0)
                      .copyWith(
                          right: obscureText ? 5 : 20, left: hasIcon ? 5 : 20),
                  decoration: BoxDecoration(
                    color: widget.background ?? theme.cardBackground,
                    borderRadius: SmoothBorderRadius(
                        cornerRadius: 20, cornerSmoothing: 0.8),
                  ),
                  child: Row(
                    children: [
                      if (hasIcon)
                        AppIconButton(
                          icon: widget.icon!,
                          background: Colors.transparent,
                          iconColor: theme.paragraph,
                        ),
                      if (hasLeading) _leading!,
                      Expanded(
                        child: TextField(
                          focusNode: _focusNode,
                          keyboardType: widget.type,
                          enabled: !widget.disabled,
                          maxLength: widget.maxLength,
                          controller: widget.controller,
                          onChanged: _handleValueChanged,
                          cursorColor: theme.paragraphDeep,
                          obscureText: !_showPassword && obscureText,
                          maxLines: obscureText ? 1 : widget.maxLines,
                          enableInteractiveSelection: !widget.disabled,
                          style: TextStyle(
                              fontSize: widget.textSize, color: theme.heading),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: widget.placeholder,
                            hintStyle: TextStyle(
                              color: theme.placeholderText,
                              fontSize: widget.placeholderSize,
                            ),
                          ),
                        ),
                      ),
                      if (!obscureText &&
                          widget.trailing != null &&
                          !widget.disabled)
                        widget.trailing!,
                      if (obscureText && !widget.disabled)
                        AppIconButton(
                          icon:
                              _showPassword ? Iconsax.eye4 : Iconsax.eye_slash,
                          onTap: () =>
                              setState(() => _showPassword = !_showPassword),
                          iconColor: _showPassword
                              ? AppColors.secondary
                              : theme.paragraph,
                        ),
                      if (widget.disabled) Icon(widget.disabledIcon, size: 16)
                    ],
                  ),
                ),
              ),
              if (widget.hint != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Wrap(
                    spacing: 10,
                    children: [
                      Icon(
                        EvaIcons.questionMarkCircleOutline,
                        color: theme.placeholderText,
                        size: 16,
                      ),
                      Text(
                        widget.hint!,
                        style: TextStyle(
                            fontSize: 13, color: theme.placeholderText),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
