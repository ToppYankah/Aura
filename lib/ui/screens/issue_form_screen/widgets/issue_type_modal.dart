import 'package:aura/ui/global_components/app_radio_button.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/issue_form_screen/models/issue_type_model.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class IssueTypeModal extends StatelessWidget {
  final IssueTypeData? selected;
  final VoidCallback onClose;
  final Function(IssueTypeData) onSelect;

  IssueTypeModal(
      {super.key,
      required this.onSelect,
      required this.onClose,
      this.selected});

  final List<IssueTypeData> issueTypes = [
    IssueTypeData(
      icon: Iconsax.cpu,
      name: "Bug Report",
      type: IssueType.bug,
    ),
    IssueTypeData(
        icon: Iconsax.message_question,
        name: "Question",
        type: IssueType.question),
    IssueTypeData(
        icon: Iconsax.hierarchy,
        name: "Feature Request",
        type: IssueType.featureRequest),
    IssueTypeData(
        icon: Iconsax.directbox_notif,
        name: "Documentation",
        type: IssueType.documentation),
    IssueTypeData(
      icon: Iconsax.more,
      name: "Other Issue",
      type: IssueType.other,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      final color = isDark ? Colors.white : Colors.grey;
      return Column(
        children: issueTypes
            .map(
              (type) => ClipRRect(
                borderRadius:
                    SmoothBorderRadius(cornerRadius: 30, cornerSmoothing: 0.8),
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    onTap: () {
                      onSelect(type);
                      onClose();
                    },
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.1),
                      child: Icon(type.icon, size: 20, color: color),
                    ),
                    trailing:
                        AppRadioButton(active: type.name == selected?.name),
                    title:
                        Text(type.name, style: const TextStyle(fontSize: 17)),
                  ),
                ),
              ),
            )
            .toList(),
      );
    });
  }
}
