import 'dart:io';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/helpers/utils/prompt_util.dart';
import 'package:aura/resources/app_colors.dart';
import 'package:aura/ui/global_components/app_header.dart';
import 'package:aura/ui/global_components/app_modal/modal_model.dart';
import 'package:aura/ui/global_components/app_prompt/app_prompt_model.dart';
import 'package:aura/ui/global_components/app_scaffold.dart';
import 'package:aura/ui/global_components/app_slide_button.dart';
import 'package:aura/ui/global_components/app_switch_button.dart';
import 'package:aura/ui/global_components/app_text_field.dart';
import 'package:aura/ui/screens/issue_form_screen/models/issue_type_model.dart';
import 'package:aura/ui/screens/issue_form_screen/widgets/issue_screenshot_upload/issue_screenshot_upload.dart';
import 'package:aura/ui/screens/issue_form_screen/widgets/issue_type_modal.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final ValueNotifier<bool> _isAnonymous = ValueNotifier<bool>(false);
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _issueTypeController = TextEditingController();
  final ValueNotifier<IssueTypeData?> _issueType =
      ValueNotifier<IssueTypeData?>(null);
  final ValueNotifier<List<File>> _attachments = ValueNotifier<List<File>>([]);

  bool get _customSubject => _issueType.value!.type == IssueType.other;

  void _handleReport() async {
    CommonUtils.callLoader(
      context,
      message: "Sending your report...",
      () async {
        await Future.delayed(const Duration(seconds: 3));
        // throw Exception("Someting went wrong!");
        _displaySuccessMessage();
        _resetForm();
      },
      onError: _displayFailureMessage,
    );
  }

  void _resetForm() {
    _issueType.value = null;
    _bodyController.clear();
    _attachments.value = [];
    _issueTypeController.clear();
  }

  void _displaySuccessMessage() {
    PromptMessage toastMessage = const PromptMessage(
      type: PromptType.success,
      title: "Thanks for reporting",
      message: "Your report has been sent successfully submitted.",
    );

    PromptUtil.show(context, toastMessage);
  }

  void _displayFailureMessage() {
    PromptMessage toastMessage = const PromptMessage(
      type: PromptType.error,
      title: "Something went wrong",
      message: "Failed to submit report. Please try again later.",
    );

    PromptUtil.show(context, toastMessage);
  }

  bool _canSubmit() {
    final String body = _bodyController.value.text;
    final String subject = _issueTypeController.value.text;

    return (_issueType.value != null && body.isNotEmpty) &&
        (_customSubject ? subject.isNotEmpty : true);
  }

  void _handleSelectIssueType() {
    CommonUtils.showModal(
      context,
      options: const ModalOptions(
        title: "Select Issue Type",
        backgroundDismissible: true,
        useHorizontalPadding: false,
      ),
      child: (onClose) => IssueTypeModal(
        onClose: onClose,
        selected: _issueType.value,
        onSelect: (type) => _issueType.value = type,
      ),
    );
  }

  void _handleFilePicked(List<File> files) => _attachments.value = [...files];

  @override
  void dispose() {
    _isAnonymous.dispose();
    _bodyController.dispose();
    _attachments.dispose();
    _issueType.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bodyBuilder: (theme, isDark) {
        return Column(
          children: [
            const SafeArea(
              bottom: false,
              child: AppHeader(title: "Report Issue"),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor:
                            (isDark ? AppColors.secondary : AppColors.primary)
                                .withOpacity(0.2),
                        child: const Text("😊", style: TextStyle(fontSize: 30)),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 40, top: 10),
                      child: Text(
                        "We're all ears! \nTell us about your issue",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: SmoothBorderRadius(
                          cornerRadius: 25, cornerSmoothing: 0.8),
                      child: Container(
                        decoration: BoxDecoration(color: theme.cardBackground),
                        child: Material(
                          color: Colors.transparent,
                          child: ValueListenableBuilder(
                            valueListenable: _issueType,
                            builder: (context, type, _) {
                              final color = isDark ? Colors.white : Colors.grey;
                              return ListTile(
                                onTap: _handleSelectIssueType,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                leading: type != null
                                    ? CircleAvatar(
                                        backgroundColor: color.withOpacity(0.1),
                                        child: Icon(type.icon,
                                            size: 20, color: color),
                                      )
                                    : null,
                                title: Text(
                                  type == null
                                      ? "Select issue type"
                                      : type.name,
                                  style: const TextStyle(fontSize: 17),
                                ),
                                trailing: const Icon(IconlyLight.arrow_right_2),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ValueListenableBuilder(
                        valueListenable: _issueType,
                        builder: (context, type, _) {
                          return (type != null && type.type == IssueType.other)
                              ? AppTextField(
                                  placeholderSize: 17,
                                  controller: _issueTypeController,
                                  placeholder: "Enter issue type here...",
                                )
                              : const SizedBox();
                        }),
                    AppTextField(
                      maxLines: 6,
                      placeholderSize: 17,
                      controller: _bodyController,
                      type: TextInputType.multiline,
                      placeholder: "Kindly describe the issue",
                    ),
                    ValueListenableBuilder(
                      valueListenable: _attachments,
                      builder: (context, attachments, _) {
                        return IssueScreenshotUpload(
                          files: attachments,
                          onFilePicked: _handleFilePicked,
                        );
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: _isAnonymous,
                      builder: (context, isAnonymous, _) {
                        return ClipRRect(
                          borderRadius: SmoothBorderRadius(cornerRadius: 20),
                          child: Material(
                            color: Colors.transparent,
                            child: ListTile(
                              enableFeedback: false,
                              title: const Wrap(
                                spacing: 10,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(Iconsax.security_safe,
                                      color: Colors.grey),
                                  Text("Keep me Anonymous",
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              trailing: AppSwitchButton(isOn: isAnonymous),
                              onTap: () => _isAnonymous.value = !isAnonymous,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            KeyboardVisibilityBuilder(
              builder: (context, isVisible) {
                return isVisible
                    ? const SizedBox()
                    : Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.14,
                          vertical: 10,
                        ).copyWith(bottom: 20),
                        child: SafeArea(
                          top: false,
                          child: ValueListenableBuilder(
                            valueListenable: _issueType,
                            builder: (context, _, __) {
                              return AppSlideButton(
                                buttonRadius: 30,
                                submitText: "report",
                                onSubmit: _handleReport,
                                disabled: !_canSubmit(),
                              );
                            },
                          ),
                        ),
                      );
              },
            )
          ],
        );
      },
    );
  }
}
