import 'package:flutter/material.dart';
import 'package:camaroo/utils/theme_constants.dart';
import 'dart:ui';

class ZoomSlider extends StatefulWidget {
  final double currentZoom;
  final double minZoom;
  final double maxZoom;
  final Function(double) onZoomChanged;

  const ZoomSlider({
    super.key,
    required this.currentZoom,
    required this.minZoom,
    required this.maxZoom,
    required this.onZoomChanged,
  });

  @override
  State<ZoomSlider> createState() => _ZoomSliderState();
}

class _ZoomSliderState extends State<ZoomSlider> {
  late double _localZoom;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _localZoom = widget.currentZoom;
  }

  @override
  void didUpdateWidget(ZoomSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isDragging && widget.currentZoom != _localZoom) {
      _localZoom = widget.currentZoom;
    }
  }

  // Define zoom stops for camera switching
  List<double> get _zoomStops {
    return [0.5, 1.0, 2.0, 5.0];
  }

  String _getZoomLabel(double zoom) {
    if (zoom <= 0.6) return '0.5x';
    if (zoom <= 1.2) return '1x';
    if (zoom <= 2.5) return '2x';
    return '${zoom.toStringAsFixed(1)}x';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Zoom label
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ThemeConstants.glassBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ThemeConstants.glassBorderColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  _getZoomLabel(_localZoom),
                  style: const TextStyle(
                    color: ThemeConstants.textAndIconColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Zoom slider
          SizedBox(
            height: 32,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background track with markers
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ZoomTrackPainter(
                      minZoom: widget.minZoom,
                      maxZoom: widget.maxZoom,
                      zoomStops: _zoomStops,
                    ),
                  ),
                ),
                
                // Slider
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 12,
                      elevation: 4,
                    ),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                    activeTrackColor: ThemeConstants.textAndIconColor,
                    inactiveTrackColor: ThemeConstants.textAndIconColor.withOpacity(0.3),
                    thumbColor: ThemeConstants.textAndIconColor,
                    overlayColor: ThemeConstants.textAndIconColor.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: _localZoom.clamp(widget.minZoom, widget.maxZoom),
                    min: widget.minZoom,
                    max: widget.maxZoom,
                    onChanged: (value) {
                      setState(() {
                        _localZoom = value;
                        _isDragging = true;
                      });
                      widget.onZoomChanged(value);
                    },
                    onChangeEnd: (value) {
                      setState(() {
                        _isDragging = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoomTrackPainter extends CustomPainter {
  final double minZoom;
  final double maxZoom;
  final List<double> zoomStops;

  _ZoomTrackPainter({
    required this.minZoom,
    required this.maxZoom,
    required this.zoomStops,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ThemeConstants.textAndIconColor.withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Draw markers for zoom stops
    for (final stop in zoomStops) {
      if (stop >= minZoom && stop <= maxZoom) {
        final position = (stop - minZoom) / (maxZoom - minZoom);
        final x = position * size.width;
        
        // Draw vertical line
        canvas.drawLine(
          Offset(x, size.height / 2 - 6),
          Offset(x, size.height / 2 + 6),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_ZoomTrackPainter oldDelegate) => false;
}