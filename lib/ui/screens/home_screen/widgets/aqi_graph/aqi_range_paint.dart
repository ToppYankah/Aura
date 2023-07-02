import 'dart:math';

import 'package:aura/resources/app_colors.dart';
import 'package:aura/resources/app_strings.dart';
import 'package:flutter/material.dart';

class AQIRangePaint extends CustomPainter {
  final Color borderColor;
  final double progress, radius, thickness;

  AQIRangePaint({
    this.thickness = 15,
    required this.radius,
    required this.progress,
    this.borderColor = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // const double strokeWidth = 15;
    const startAngle = 3 * pi / 4;
    const sweepAngle = 3 * pi / 2;
    final double sweepRadius = radius - 15;
    const Offset sweepCenter = Offset(0, 0);
    final List<Color> gradientColorArray = [
      AppColors.goodRange,
      AppColors.moderateRange,
      AppColors.unhealthyFCGRange,
      AppColors.unhealthyRange,
      AppColors.veryUnhealthyRange,
      AppColors.hazardousRange,
    ];
    final Rect sweepRect =
        Rect.fromCircle(center: sweepCenter, radius: sweepRadius);

    final Paint gradientArc = Paint()
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..color = Colors.red.shade200
      ..style = PaintingStyle.stroke
      ..shader = SweepGradient(
        startAngle: 3 * pi / 9,
        endAngle: 3 * pi / 1.8,
        colors: gradientColorArray,
        transform: const GradientRotation(pi / 2),
      ).createShader(sweepRect);

    final Paint greyArc = Paint()
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..color = Colors.grey.shade300;

    // final Paint whiteArc = Paint()
    //   ..color = borderColor
    //   ..strokeCap = StrokeCap.round
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = thickness * 2;

    // canvas.drawArc(
    //   sweepRect,
    //   startAngle,
    //   sweepAngle,
    //   false,
    //   whiteArc,
    // );
    canvas.drawArc(
      sweepRect,
      startAngle,
      sweepAngle,
      false,
      greyArc,
    );
    canvas.drawArc(
      sweepRect,
      startAngle,
      sweepAngle * progress, // 3 * (pi * progress) / (2),
      false,
      gradientArc,
    );

    _paintRangeLimits(canvas);
  }

  void _paintRangeLimits(Canvas canvas) {
    const TextStyle textStyle = TextStyle(
      fontSize: 13,
      color: Colors.white54,
      fontWeight: FontWeight.w400,
      fontFamily: AppFonts.lufgaFont,
    );

    const minSpan = TextSpan(text: '0', style: textStyle);
    // ----------------
    const maxSpan = TextSpan(text: '500', style: textStyle);

    final minTextPainter =
        TextPainter(text: minSpan, textDirection: TextDirection.ltr);
    // ----------------
    final maxTextPainter =
        TextPainter(text: maxSpan, textDirection: TextDirection.ltr);

    minTextPainter.layout(minWidth: 0, maxWidth: 100);
    // ----------------
    maxTextPainter.layout(minWidth: 0, maxWidth: 100);

    // const minTextOffset = Offset(-65, 60);
    // ----------------
    // const maxTextOffset = Offset(40, 60);

    // minTextPainter.paint(canvas, minTextOffset);
    // // ----------------
    // maxTextPainter.paint(canvas, maxTextOffset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
