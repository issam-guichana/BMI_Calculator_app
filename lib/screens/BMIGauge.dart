import 'dart:math';
import 'package:flutter/material.dart';

class BMIGaugePainter extends CustomPainter {
  final double bmi;

  BMIGaugePainter(this.bmi);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0;

    // Define angles and colors for segments
    double startAngle = -pi;
    double sweepAngle = pi / 4;
    List<Color> segmentColors = [
      Colors.brown[300]!, // Underweight
      Colors.green[600]!, // Normal weight
      Colors.orange[500]!, // Overweight
      Colors.red[800]!, // Obese
    ];

    // Draw the segments
    for (int i = 0; i < segmentColors.length; i++) {
      paint.color = segmentColors[i];
      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
        startAngle + i * sweepAngle,
        sweepAngle,
        false,
        paint,
      );
    }

    // Determine the angle for the needle based on BMI value
    double needleAngle;
    if (bmi < 18.5) {
      needleAngle = startAngle + (bmi / 18.5) * sweepAngle; // Underweight range
    } else if (bmi < 25.0) {
      needleAngle = startAngle + sweepAngle + ((bmi - 18.5) / (25.0 - 18.5)) * sweepAngle; // Normal weight range
    } else if (bmi < 30.0) {
      needleAngle = startAngle + 2 * sweepAngle + ((bmi - 25.0) / (30.0 - 25.0)) * sweepAngle; // Overweight range
    } else {
      needleAngle = startAngle + 3 * sweepAngle + min((bmi - 30.0) / 10.0, 1.0) * sweepAngle; // Obese range
    }

    // Draw the needle as a triangle
    paint.color = Colors.black;
    paint.style = PaintingStyle.fill;

    double needleLength = size.width / 2;
    double baseWidth = 20.0;
    Offset center = Offset(size.width / 2, size.height / 2);
    Offset tip = Offset(
      center.dx + needleLength * cos(needleAngle),
      center.dy + needleLength * sin(needleAngle),
    );

    Path needlePath = Path();
    needlePath.moveTo(tip.dx, tip.dy);
    needlePath.lineTo(
      center.dx + baseWidth / 2 * cos(needleAngle + pi / 2),
      center.dy + baseWidth / 2 * sin(needleAngle + pi / 2),
    );
    needlePath.lineTo(
      center.dx + baseWidth / 2 * cos(needleAngle - pi / 2),
      center.dy + baseWidth / 2 * sin(needleAngle - pi / 2),
    );
    needlePath.close();

    canvas.drawPath(needlePath, paint);
  }

  @override
  bool shouldRepaint(covariant BMIGaugePainter oldDelegate) {
    return oldDelegate.bmi != bmi;
  }
}
