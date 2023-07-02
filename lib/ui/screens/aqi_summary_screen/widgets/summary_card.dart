import 'package:aura/helpers/utils/aqi_util.dart';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/app_icon_button.dart';
import 'package:aura/ui/global_components/app_modal/modal_model.dart';
import 'package:aura/ui/global_components/section_card.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class SummaryCard extends StatefulWidget {
  final bool selected;
  final AQIStatus status;
  const SummaryCard({super.key, this.selected = false, required this.status});

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  @override
  void initState() {
    super.initState();
    CommonUtils.performPostBuild(context, () {
      if (widget.selected) {
        Scrollable.ensureVisible((widget.key as GlobalKey).currentContext!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      return SectionCard(
        useHorizontalSpace: true,
        showInteractiveIndicator: false,
        onTap: () => CommonUtils.showModal(
          context,
          options: ModalOptions(title: widget.status.name),
          child: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.status.healthTip.entries
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Wrap(
                          spacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            AppIconButton(
                              icon: IconlyLight.user_1,
                              iconSize: 18,
                              radius: 18,
                              background: (isDark
                                      ? AppColors.secondary
                                      : AppColors.primary)
                                  .withOpacity(0.2),
                              iconColor: isDark
                                  ? AppColors.secondary
                                  : AppColors.primary.shade300,
                            ),
                            Text(
                              e.key,
                              style: TextStyle(
                                fontSize: 16,
                                color: theme.paragraphDeep,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          e.value,
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 16,
                            color: theme.paragraph,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        background: widget.selected ? AppColors.primary : null,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(image: widget.status.icon, width: 40),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.status.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.selected ? Colors.white : theme.heading,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        widget.status.message,
                        style: TextStyle(
                          fontSize: 15,
                          color: widget.selected
                              ? Colors.white70
                              : theme.paragraphDeep,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
