import 'package:flutter/material.dart';
import 'package:camaroo/utils/theme_constants.dart';
import 'dart:ui';
import 'dart:math' as math;

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

  // Convert linear slider position (0-1) to logarithmic zoom value
  double _sliderToZoom(double sliderValue) {
    final minLog = math.log(widget.minZoom);
    final maxLog = math.log(widget.maxZoom);
    final logValue = minLog + (sliderValue * (maxLog - minLog));
    return math.exp(logValue);
  }

  // Convert logarithmic zoom value to linear slider position (0-1)
  double _zoomToSlider(double zoom) {
    final minLog = math.log(widget.minZoom);
    final maxLog = math.log(widget.maxZoom);
    final logZoom = math.log(zoom);
    return (logZoom - minLog) / (maxLog - minLog);
  }

  // Define zoom stops for visual markers
  List<double> get _zoomStops {
    // Common zoom values that should be marked
    List<double> stops = [0.5, 1.0, 2.0, 5.0, 10.0];
    // Only include stops within the valid range
    return stops.where((z) => z >= widget.minZoom && z <= widget.maxZoom).toList();
  }

  String _getZoomLabel(double zoom) {
    if (zoom < 1) {
      return '${zoom.toStringAsFixed(1)}x';
    } else if (zoom < 10) {
      return '${zoom.toStringAsFixed(1)}x';
    } else {
      return '${zoom.toStringAsFixed(0)}x';
    }
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
          
          // Zoom slider with logarithmic scaling
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
                      zoomToSlider: _zoomToSlider,
                    ),
                  ),
                ),
                
                // Slider (0-1 linear, but represents logarithmic zoom)
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
                    value: _zoomToSlider(_localZoom.clamp(widget.minZoom, widget.maxZoom)),
                    min: 0.0,
                    max: 1.0,
                    onChanged: (sliderValue) {
                      final zoomValue = _sliderToZoom(sliderValue);
                      setState(() {
                        _localZoom = zoomValue;
                        _isDragging = true;
                      });
                      widget.onZoomChanged(zoomValue);
                    },
                    onChangeEnd: (sliderValue) {
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
  final double Function(double) zoomToSlider;

  _ZoomTrackPainter({
    required this.minZoom,
    required this.maxZoom,
    required this.zoomStops,
    required this.zoomToSlider,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ThemeConstants.textAndIconColor.withOpacity(0.4)
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
  bool shouldRepaint(_ZoomTrackPainter oldDelegate) => false;
}