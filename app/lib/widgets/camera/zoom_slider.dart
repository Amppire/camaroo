import 'package:flutter/material.dart';
import 'package:camaroo/utils/theme_constants.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:camaroo/utils/painters/zoom_track_painter.dart';

class ZoomSlider extends StatelessWidget {

  final double currentZoom;
  final double minZoom;
  final double maxZoom;
  final Function(double) onZoomChanged;

  ZoomSlider({
    super.key,
    required this.currentZoom,
    required this.minZoom,
    required this.maxZoom,
    required this.onZoomChanged,
  });


  late final ValueNotifier<double> _localZoomNotifier = ValueNotifier(currentZoom);
  final ValueNotifier<bool> _isDraggingNotifier = ValueNotifier(false);



  // Convert linear slider position (0-1) to logarithmic zoom value
  double _sliderToZoom(double sliderValue) {
    final minLog = math.log(minZoom);
    final maxLog = math.log(maxZoom);
    final logValue = minLog + (sliderValue * (maxLog - minLog));
    return math.exp(logValue);
  }

  // Convert logarithmic zoom value to linear slider position (0-1)
  double _zoomToSlider(double zoom) {
    final minLog = math.log(minZoom);
    final maxLog = math.log(maxZoom);
    final logZoom = math.log(zoom);
    return (logZoom - minLog) / (maxLog - minLog);
  }

  // Define zoom stops for visual markers
  List<double> get _zoomStops {
    // Common zoom values that should be marked
    List<double> stops = [0.5, 1.0, 2.0, 5.0, 10.0];
    // Only include stops within the valid range
    return stops
        .where((z) => z >= minZoom && z <= maxZoom)
        .toList();
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ThemeConstants.glassBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ThemeConstants.glassBorderColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  _getZoomLabel(_localZoomNotifier.value),
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
                    painter: ZoomTrackPainter(
                      minZoom: minZoom,
                      maxZoom: maxZoom,
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
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 20,
                    ),
                    activeTrackColor: ThemeConstants.textAndIconColor,
                    inactiveTrackColor: ThemeConstants.textAndIconColor
                        .withValues(alpha: 0.3),
                    thumbColor: ThemeConstants.textAndIconColor,
                    overlayColor: ThemeConstants.textAndIconColor.withValues(alpha: 0.2)
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: _localZoomNotifier,
                    builder: (context, double localZoom, _) =>
                        ValueListenableBuilder(
                          valueListenable: _isDraggingNotifier,
                          builder: (context, bool isDragging, _) => Slider(
                            value: _zoomToSlider(
                              localZoom.clamp(minZoom, maxZoom),
                            ),
                            min: 0.0,
                            max: 1.0,
                            onChanged: (sliderValue) {
                              final zoomValue = _sliderToZoom(sliderValue);
                              _localZoomNotifier.value = zoomValue;
                              _isDraggingNotifier.value = true;
                              onZoomChanged(zoomValue);
                            },
                            onChangeEnd: (sliderValue) {
                              _isDraggingNotifier.value = false;
                            },
                          ),
                        ),
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

