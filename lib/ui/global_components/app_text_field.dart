import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/app_icon_button.dart';
import 'package:aura/ui/global_components/app_text_button.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AppTextField extends StatefulWidget {
  final String? hint;
  final bool disabled;
  final int? maxLines;
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
  bool _showPassword = false;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.focusNode != null) _focusNode = widget.focusNode!;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasIcon = widget.icon != null;
    final bool hasLeading = widget.leading != null;
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
                      if (hasLeading) widget.leading!,
                      Expanded(
                        child: TextField(
                          focusNode: _focusNode,
                          keyboardType: widget.type,
                          enabled: !widget.disabled,
                          onChanged: widget.onChange,
                          controller: widget.controller,
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
                            fontSize: 14, color: theme.placeholderText),
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
