class ImageUtils {
  /// Converts shutter speed in seconds to a readable format
  static String formatShutterSpeed(double speed) {
    if (speed >= 1) {
      return '${speed.toStringAsFixed(1)}s';
    } else {
      final denominator = (1 / speed).round();
      return '1/$denominator';
    }
  }

  /// Converts ISO value to readable format
  static String formatISO(double iso) {
    return 'ISO ${iso.round()}';
  }

  /// Converts focal length to readable format
  static String formatFocalLength(double length) {
    return '${length.round()}mm';
  }

  /// Converts white balance to readable format
  static String formatWhiteBalance(double kelvin) {
    return '${kelvin.round()}K';
  }

  /// Gets white balance preset name
  static String getWhiteBalancePreset(double kelvin) {
    if (kelvin < 3000) return 'Tungsten';
    if (kelvin < 4000) return 'Fluorescent';
    if (kelvin < 5500) return 'Daylight';
    if (kelvin < 6500) return 'Cloudy';
    if (kelvin < 8000) return 'Shade';
    return 'Custom';
  }

  /// Calculates exposure value (EV)
  static double calculateEV(double shutterSpeed, double iso) {
    // Simplified EV calculation
    // EV = log2(N^2 / t) - log2(ISO/100)
    final aperture = 2.8; // Assuming fixed aperture
    final ev = (2 * (aperture * aperture) / shutterSpeed).toDouble();
    return ev - (iso / 100);
  }

  /// Gets file size in human-readable format
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Generates a unique filename for photos
  static String generatePhotoFilename({String prefix = 'IMG', String extension = 'jpg'}) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${prefix}_$timestamp.$extension';
  }
}
