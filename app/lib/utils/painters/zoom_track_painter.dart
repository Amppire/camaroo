import 'package:flutter/material.dart';
import 'package:camaroo/utils/theme_constants.dart';

class ZoomTrackPainter extends CustomPainter {
  final double minZoom;
  final double maxZoom;
  final List<double> zoomStops;
  final double Function(double) zoomToSlider;

  ZoomTrackPainter({
    required this.minZoom,
    required this.maxZoom,
    required this.zoomStops,
    required this.zoomToSlider,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ThemeConstants.textAndIconColor.withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Draw markers for zoom stops (using logarithmic positions)
    for (final stop in zoomStops) {
      final position = zoomToSlider(stop);
      final x = position * size.width;

      // Draw vertical line
      canvas.drawLine(
        Offset(x, size.height / 2 - 6),
        Offset(x, size.height / 2 + 6),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ZoomTrackPainter oldDelegate) => false;
}
