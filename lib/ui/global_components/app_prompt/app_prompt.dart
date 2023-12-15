import 'dart:ui';

import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/app_button.dart';
import 'package:aura/ui/global_components/app_prompt/app_prompt_model.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class AppPromptModal extends StatefulWidget {
  final VoidCallback onClose;
  final PromptMessage message;
  final PromptOptions options;

  const AppPromptModal({
    super.key,
    required this.onClose,
    required this.message,
    required this.options,
  });

  @override
  State<AppPromptModal> createState() => _AppPromptModalState();
}

class _AppPromptModalState extends State<AppPromptModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  )..forward();

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastEaseInToSlowEaseOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late IconData badgeIcon;
    late Color badgeColor;

    switch (widget.message.type) {
      case PromptType.success:
        badgeIcon = Icons.check_rounded;
        badgeColor = Colors.green.shade400;
        break;
      case PromptType.error:
        badgeIcon = Icons.close_rounded;
        badgeColor = Colors.red;
        break;
      case PromptType.warning:
        badgeIcon = Icons.warning_amber_rounded;
        badgeColor = AppColors.secondary;
        break;
      default:
        badgeIcon = Icons.info_outline_rounded;
        badgeColor = Colors.grey;
    }

    return WillPopScope(
      onWillPop: () async {
        widget.onClose();
        return false;
      },
      child: Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              const Positioned.fill(
                child: Material(color: Colors.black87),
              ),
              Align(
                alignment: widget.options.getAlignment,
                child: ScaleTransition(
                  scale: _animation,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: ThemeBuilder(
                      builder: (theme, isDark) {
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.white10
                                          : Colors.white.withOpacity(0.9),
                                      borderRadius:
                                          const SmoothBorderRadius.all(
                                        SmoothRadius(
                                            cornerRadius: 30,
                                            cornerSmoothing: 0.8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor:
                                        badgeColor.withOpacity(0.3),
                                    child: Icon(
                                      badgeIcon,
                                      color: badgeColor,
                                      size: 35,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    widget.message.title,
                                    textAlign: TextAlign.center,
                                    style: theme.styles!.paragraph.copyWith(
                                      color: theme.heading,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          widget.message.message,
                                          textAlign: TextAlign.center,
                                          style: theme.styles!.paragraph
                                              .copyWith(
                                                  color: theme.paragraph,
                                                  fontSize: theme.styles!
                                                          .paragraph.fontSize! *
                                                      0.85),
                                        ),
                                        const SizedBox(height: 20),
                                        _getActions(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _getActions() {
    final bool isRequest = widget.message.onOk != null;

    return Row(
      children: [
        ThemeBuilder(builder: (_, isDark) {
          return Expanded(
            child: AppButton(
              onTap: widget.onClose,
              background: isDark ? Colors.white24 : null,
              padding: const EdgeInsets.symmetric(vertical: 15),
              text: isRequest ? widget.message.cancelText : "Dismiss",
            ),
          );
        }),
        if (isRequest) ...[
          const SizedBox(width: 10),
          ThemeBuilder(builder: (_, isDark) {
            return Expanded(
              child: AppButton(
                onTap: () async {
                  await widget.message.onOk!();
                  widget.onClose();
                },
                text: widget.message.okayText,
                background: isDark ? Colors.white24 : null,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            );
          }),
        ]
      ],
    );
  }
}
