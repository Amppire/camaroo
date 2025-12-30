import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:native_camera_kit/native_camera_kit.dart';

/// Simple zoom slider for testing camera zoom functionality
/// Uses logarithmic scaling for better control at lower focal lengths
class ZoomSlider extends StatelessWidget {
  const ZoomSlider({
    super.key,
    required this.controller,
  });

  final NativeCameraController controller;

  /// Convert focal length to logarithmic slider value
  double _focalLengthToSlider(double focalLength, double min, double max) {
    if (focalLength <= 0 || min <= 0) return 0;
    final logMin = math.log(min);
    final logMax = math.log(max);
    final logCurrent = math.log(focalLength);
    return (logCurrent - logMin) / (logMax - logMin);
  }

  /// Convert logarithmic slider value to focal length
  double _sliderToFocalLength(double sliderValue, double min, double max) {
    if (min <= 0) return min;
    final logMin = math.log(min);
    final logMax = math.log(max);
    final logValue = logMin + sliderValue * (logMax - logMin);
    return math.exp(logValue);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double?>(
      valueListenable: controller.focalLength,
      builder: (context, currentFocalLength, _) {
        return ValueListenableBuilder<double?>(
          valueListenable: controller.minFocalLength,
          builder: (context, minFocalLength, _) {
            return ValueListenableBuilder<double?>(
              valueListenable: controller.maxFocalLength,
              builder: (context, maxFocalLength, _) {
                // Don't show slider if values aren't available
                if (currentFocalLength == null ||
                    minFocalLength == null ||
                    maxFocalLength == null ||
                    minFocalLength >= maxFocalLength) {
                  return const SizedBox.shrink();
                }

                // Convert current focal length to logarithmic slider position
                final sliderValue = _focalLengthToSlider(
                  currentFocalLength,
                  minFocalLength,
                  maxFocalLength,
                ).clamp(0.0, 1.0);

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Current focal length display
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${currentFocalLength.toStringAsFixed(1)}mm',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Slider with logarithmic scaling
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white.withOpacity(0.3),
                          thumbColor: Colors.white,
                          overlayColor: Colors.white.withOpacity(0.3),
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 8,
                          ),
                        ),
                        child: Slider(
                          value: sliderValue,
                          min: 0.0,
                          max: 1.0,
                          onChanged: (value) {
                            // Convert logarithmic slider value back to focal length
                            final focalLength = _sliderToFocalLength(
                              value,
                              minFocalLength,
                              maxFocalLength,
                            );
                            controller.setFocalLength(focalLength);
                          },
                        ),
                      ),

                      // Min/Max labels
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${minFocalLength.toStringAsFixed(0)}mm',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${maxFocalLength.toStringAsFixed(0)}mm',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

