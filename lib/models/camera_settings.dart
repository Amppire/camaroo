class CameraSettings {
  double shutterSpeed; // in seconds
  double exposureTime; // in seconds
  double iso;
  double focalLength;
  bool portraitMode;
  double whiteBalance;
  FocusMode focusMode;
  bool gridOverlay;
  bool showHistogram;
  FlashMode flashMode;
  
  CameraSettings({
    this.shutterSpeed = 1 / 125,
    this.exposureTime = 1 / 125,
    this.iso = 100,
    this.focalLength = 24,
    this.portraitMode = false,
    this.whiteBalance = 5500,
    this.focusMode = FocusMode.auto,
    this.gridOverlay = false,
    this.showHistogram = false,
    this.flashMode = FlashMode.auto,
  });

  Map<String, dynamic> toJson() {
    return {
      'shutterSpeed': shutterSpeed,
      'exposureTime': exposureTime,
      'iso': iso,
      'focalLength': focalLength,
      'portraitMode': portraitMode,
      'whiteBalance': whiteBalance,
      'focusMode': focusMode.toString(),
      'gridOverlay': gridOverlay,
      'showHistogram': showHistogram,
      'flashMode': flashMode.toString(),
    };
  }
}

enum FocusMode {
  auto,
  manual,
  continuous,
}

enum FlashMode {
  auto,
  on,
  off,
  torch,
}
