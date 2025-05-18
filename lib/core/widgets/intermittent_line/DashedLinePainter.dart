import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  final double lineHeight;
  final Color lineColor;
  final double dashWidth;
  final double dashSpace;

  DashedLinePainter({
    required this.lineHeight,
    required this.lineColor,
    this.dashWidth = 10.0,
    this.dashSpace = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineHeight;

    // Draw dashed line
    double startX = 0;
    while (startX +5< size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
