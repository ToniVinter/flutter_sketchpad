import 'package:flutter/material.dart';
import 'sketch_insert.dart';

/// Custom painter for rendering sketch inserts
class SketchInsertPainter extends CustomPainter {
  SketchInsertPainter({
    required this.inserts,
    required this.currentPoints,
    required this.currentStrokeWidth,
    required this.currentColor,
  });

  final List<SketchInsert> inserts;
  final List<Offset> currentPoints;
  final double currentStrokeWidth;
  final Color currentColor;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw saved inserts
    for (final insert in inserts) {
      if (insert.type == SketchInsertType.drawing) {
        _drawPath(canvas, insert.points, insert.color, insert.strokeWidth);
      }
    }

    // Draw current stroke being drawn
    if (currentPoints.isNotEmpty) {
      _drawPath(canvas, currentPoints, currentColor, currentStrokeWidth);
    }
  }

  void _drawPath(
    Canvas canvas,
    List<Offset> points,
    Color color,
    double strokeWidth,
  ) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SketchInsertPainter oldDelegate) {
    return oldDelegate.inserts != inserts ||
        oldDelegate.currentPoints != currentPoints ||
        oldDelegate.currentStrokeWidth != currentStrokeWidth ||
        oldDelegate.currentColor != currentColor;
  }
}
