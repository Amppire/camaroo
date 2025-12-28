import 'package:flutter/material.dart';
import 'package:camaroo/utils/theme_constants.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:camaroo/utils/painters/zoom_track_painter.dart';

class ZoomSlider extends StatefulWidget {

  final double currentFocalLength; // in mm
  final double minFocalLength; // in mm
  final double maxFocalLength; // in mm
  final List<double> focalLengthStops; // in mm (camera switch points)
  final Function(double) onFocalLengthChanged; // receives mm value

  const ZoomSlider({
    super.key,
    required this.currentFocalLength,
    required this.minFocalLength,
    required this.maxFocalLength,
    required this.focalLengthStops,
    required this.onFocalLengthChanged,
  });

  @override
  State<ZoomSlider> createState() => _ZoomSliderState();
}

class _ZoomSliderState extends State<ZoomSlider> {
  late ValueNotifier<double> _localFocalLengthNotifier;
  final ValueNotifier<bool> _isDraggingNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _localFocalLengthNotifier = ValueNotifier(widget.currentFocalLength);
  }

  @override
  void didUpdateWidget(ZoomSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentFocalLength != widget.currentFocalLength) {
      _localFocalLengthNotifier.value = widget.currentFocalLength;
    }
  }

  @override
  void dispose() {
    _localFocalLengthNotifier.dispose();
    _isDraggingNotifier.dispose();
    super.dispose();
  }

  // Convert linear slider position (0-1) to logarithmic focal length (mm)
  double _sliderToFocalLength(double sliderValue) {
    final minLog = math.log(widget.minFocalLength);
    final maxLog = math.log(widget.maxFocalLength);
    final logValue = minLog + (sliderValue * (maxLog - minLog));
    final focalLength = math.exp(logValue);
    
    // Clamp and validate
    if (focalLength.isNaN || focalLength.isInfinite || focalLength <= 0) {
      return widget.minFocalLength;
    }
    return focalLength.clamp(widget.minFocalLength, widget.maxFocalLength);
  }

  // Convert logarithmic focal length (mm) to linear slider position (0-1)
  double _focalLengthToSlider(double focalLength) {
    if (focalLength <= 0 || focalLength.isNaN || focalLength.isInfinite) {
      return 0.0;
    }
    
    final clamped = focalLength.clamp(widget.minFocalLength, widget.maxFocalLength);
    final minLog = math.log(widget.minFocalLength);
    final maxLog = math.log(widget.maxFocalLength);
    final logFocalLength = math.log(clamped);
    
    final sliderValue = (logFocalLength - minLog) / (maxLog - minLog);
    
    // Clamp to 0-1 range
    return sliderValue.clamp(0.0, 1.0);
  }

  String _getFocalLengthLabel(double focalLength) {
    // Format like iOS: "13mm", "26mm", "52mm"
    if (focalLength < 10) {
      return '${focalLength.toStringAsFixed(1)}mm';
    } else {
      return '${focalLength.toStringAsFixed(0)}mm';
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
          // Focal length label
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
                child: ValueListenableBuilder(
                  valueListenable: _localFocalLengthNotifier,
                  builder: (context, double localFocalLength, _) => Text(
                    _getFocalLengthLabel(localFocalLength),
                    style: const TextStyle(
                      color: ThemeConstants.textAndIconColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Focal length slider with logarithmic scaling
          ValueListenableBuilder(
            valueListenable: _localFocalLengthNotifier,
            builder: (context, double localFocalLength, _) =>
                ValueListenableBuilder(
                  valueListenable: _isDraggingNotifier,
                  builder: (context, bool isDragging, _) => SizedBox(
                    height: 32,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background track with markers
                        Positioned.fill(
                          child: CustomPaint(
                            painter: ZoomTrackPainter(
                              minZoom: widget.minFocalLength,
                              maxZoom: widget.maxFocalLength,
                              zoomStops: widget.focalLengthStops,
                              zoomToSlider: _focalLengthToSlider,
                            ),
                          ),
                        ),

                        // Slider (0-1 linear, but represents logarithmic focal length)
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
                          child: Slider(
                            value: _focalLengthToSlider(
                              localFocalLength.clamp(widget.minFocalLength, widget.maxFocalLength),
                            ),
                            min: 0.0,
                            max: 1.0,
                            onChanged: (sliderValue) {
                              final focalLengthValue = _sliderToFocalLength(sliderValue);
                              _localFocalLengthNotifier.value = focalLengthValue;
                              _isDraggingNotifier.value = true;
                              widget.onFocalLengthChanged(focalLengthValue);
                            },
                            onChangeEnd: (sliderValue) {
                              _isDraggingNotifier.value = false;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
