
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;

    double dashWidth = 10.0;
    double dashSpace = 5.0;

    // Draw vertical line on the start of the screen
    for (double y = 0; y < size.height; y += dashWidth + dashSpace) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dashWidth), paint);
    }

    // Draw vertical line on the end of the screen
    for (double y = 0; y < size.height; y += dashWidth + dashSpace) {
      canvas.drawLine(Offset(size.width, y), Offset(size.width, y + dashWidth), paint);
    }

    // Draw horizontal line on the bottom of the screen
    for (double x = 5; x < size.width; x += dashWidth + dashSpace) {
      canvas.drawLine(Offset(x, size.height),
          Offset(x + dashWidth, size.height), paint);
    }


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
