import 'package:flutter/material.dart';

class ConcentrationMeterPaint extends CustomPainter {
  final Color color, trackColor;
  final double value;
  ConcentrationMeterPaint({
    required this.value,
    required this.color,
    this.trackColor = Colors.white10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint trackPaint = Paint()
      ..strokeWidth = 3
      ..color = trackColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Paint linePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), trackPaint);
    canvas.drawLine(Offset(0, size.height),
        Offset(0, size.height - (size.height * value)), linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
