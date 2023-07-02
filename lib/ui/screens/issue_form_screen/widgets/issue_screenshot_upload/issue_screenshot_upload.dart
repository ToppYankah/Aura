import 'dart:io';
import 'package:aura/helpers/utils/common_utils.dart';
import 'package:aura/helpers/utils/prompt_util.dart';
import 'package:aura/ui/global_components/app_prompt/app_prompt_model.dart';
import 'package:aura/ui/global_components/theme_builder.dart';
import 'package:aura/ui/screens/issue_form_screen/widgets/issue_screenshot_upload/widgets/add_screenshot_tile.dart';
import 'package:aura/ui/screens/issue_form_screen/widgets/issue_screenshot_upload/widgets/screenshot_tile.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class IssueScreenshotUpload extends StatefulWidget {
  final List<File> files;
  final Function(List<File>) onFilePicked;
  const IssueScreenshotUpload(
      {super.key, required this.onFilePicked, required this.files});

  @override
  State<IssueScreenshotUpload> createState() => _IssueScreenshotUploadState();
}

class _IssueScreenshotUploadState extends State<IssueScreenshotUpload> {
  final int maxUploads = 3;
  final List<File> _screenshots = [];

  @override
  void didUpdateWidget(covariant IssueScreenshotUpload oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.files.isEmpty && _screenshots.isNotEmpty && mounted) {
      setState(() => _screenshots.clear());
    }
  }

  void _handleAddScreenshot() async {
    List<File>? pickedFiles = await CommonUtils.pickImages(max: maxUploads);

    if (pickedFiles != null) {
      return setState(() {
        _screenshots.addAll(
          pickedFiles.where(
            (element) => _screenshots
                .where((i) => hasEqualPaths(i.path, element.path))
                .isEmpty,
          ),
        );

        widget.onFilePicked(_screenshots);
      });
    }

    _alertUploadFailure();
  }

  bool hasEqualPaths(String path1, String path2) {
    return path1.split("/").last == path2.split("/").last;
  }

  void _alertUploadFailure() {
    PromptMessage toastMessage = const PromptMessage(
      type: PromptType.error,
      title: "Something went wrong",
      message: "Unable to add photo(s) from your\nphoto library.",
    );

    PromptUtil.show(context, toastMessage);
  }

  void _handleRemoveScreenshot(File screenshot) {
    setState(() {
      _screenshots.removeWhere((element) => element == screenshot);
      widget.onFilePicked(_screenshots);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(builder: (theme, isDark) {
      final Color color = isDark ? Colors.white : Colors.grey;
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: theme.cardBackground,
          borderRadius:
              SmoothBorderRadius(cornerRadius: 25, cornerSmoothing: 0.8),
        ),
        child: DottedBorder(
          strokeWidth: 2,
          strokeCap: StrokeCap.round,
          borderType: BorderType.RRect,
          color: color.withOpacity(0.1),
          dashPattern: const [5, 10],
          radius: const SmoothRadius(cornerRadius: 20, cornerSmoothing: 0.8),
          child: LayoutBuilder(builder: (context, constraints) {
            const double boxHeight = 140;
            final double boxWidth = ((constraints.maxWidth - 18) * 0.33);
            final Size boxSize = Size(boxWidth, boxHeight);

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _screenshots.isEmpty ? _handleAddScreenshot : null,
                borderRadius:
                    SmoothBorderRadius(cornerRadius: 20, cornerSmoothing: 0.8),
                child: Container(
                  constraints: const BoxConstraints(minHeight: boxHeight + 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: _screenshots.isEmpty
                      ? const Center(
                          child: Opacity(
                            opacity: 0.3,
                            child: Wrap(
                              spacing: 10,
                              direction: Axis.vertical,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Icon(Iconsax.camera, size: 30),
                                Text(
                                  "Tap to add\nup to 3 screenshots",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: [
                            for (final File screenshot in _screenshots)
                              ScreenshotTile(
                                size: boxSize,
                                file: screenshot,
                                onRemove: () =>
                                    _handleRemoveScreenshot(screenshot),
                              ),
                            if (_screenshots.length < maxUploads)
                              AddScreenshotTile(
                                size: boxSize,
                                onAdd: _handleAddScreenshot,
                              ),
                          ],
                        ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
