import 'dart:io';

import 'package:aura/ui/global_components/app_text_button.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class ScreenshotTile extends StatelessWidget {
  final File file;
  final Size size;
  final VoidCallback onRemove;
  const ScreenshotTile({
    super.key,
    required this.file,
    required this.size,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white10,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(file),
        ),
        borderRadius:
            SmoothBorderRadius(cornerRadius: 20, cornerSmoothing: 0.8),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: AppTextButton(
              textSize: 12,
              text: "cancel",
              onTap: onRemove,
              color: Colors.grey,
              enableBackground: true,
              icon: Icons.delete_outline,
              explicitBackground: Colors.black87,
            ),
          )
        ],
      ),
    );
  }
}
