import 'dart:ui';

import 'package:aura/ui/global_components/app_icon_button.dart';
import 'package:aura/ui/global_components/app_modal/modal_model.dart';
import 'package:aura/ui/global_components/section_card.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class AppModal extends StatefulWidget {
  final VoidCallback onClose;
  final ModalOptions options;
  final Widget Function(VoidCallback closeModal)? child;

  const AppModal({
    super.key,
    this.child,
    required this.options,
    required this.onClose,
  });

  @override
  State<AppModal> createState() => _AppModalState();
}

class _AppModalState extends State<AppModal>
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
    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: widget.options.backgroundDismissible
                    ? widget.onClose
                    : null,
                child: const Material(color: Colors.black87),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ScaleTransition(
                scale: _animation,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ThemeBuilder(
                    builder: (theme, isDark) {
                      return SectionCard(
                        background: Colors.transparent,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                  child: Container(
                                    color: isDark
                                        ? Colors.white10
                                        : Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal:
                                      widget.options.useHorizontalPadding
                                          ? 20
                                          : 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                            horizontal: widget.options
                                                    .useHorizontalPadding
                                                ? 0
                                                : 10)
                                        .copyWith(bottom: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (widget.options.title != null)
                                          Expanded(
                                            child: Text(
                                              widget.options.title!,
                                              style: TextStyle(
                                                color: theme.heading,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        else
                                          const SizedBox(),
                                        AppIconButton(
                                          icon: EvaIcons.close,
                                          onTap: widget.onClose,
                                          radius: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (widget.child != null)
                                    widget.child!(widget.onClose),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
