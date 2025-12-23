import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import '../models/camera_settings.dart';

class CameraService extends ChangeNotifier {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  CameraSettings _settings = CameraSettings();
  bool _isInitialized = false;
  String? _error;

  CameraController? get controller => _controller;
  List<CameraDescription> get cameras => _cameras;
  CameraSettings get settings => _settings;
  bool get isInitialized => _isInitialized;
  String? get error => _error;

  Future<void> initialize() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _error = 'No cameras found';
        notifyListeners();
        return;
      }

      await _initializeCamera(_cameras.first);
    } catch (e) {
      _error = 'Failed to initialize camera: $e';
      notifyListeners();
    }
  }

  Future<void> _initializeCamera(CameraDescription camera) async {
    _controller = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _controller!.initialize();
      _isInitialized = true;
      await applySettings();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to initialize camera: $e';
      notifyListeners();
    }
  }

  Future<void> switchCamera() async {
    if (_cameras.length < 2) return;

    final currentIndex = _cameras.indexOf(_controller!.description);
    final nextIndex = (currentIndex + 1) % _cameras.length;
    
    await _controller?.dispose();
    await _initializeCamera(_cameras[nextIndex]);
  }

  Future<void> applySettings() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      // Apply exposure
      await _controller!.setExposureOffset(_settings.exposureTime * 10 - 5);
      
      // Apply focus mode
      if (_settings.focusMode == FocusMode.auto) {
        await _controller!.setFocusMode(camera.FocusMode.auto);
      } else if (_settings.focusMode == FocusMode.continuous) {
        await _controller!.setFocusMode(camera.FocusMode.auto);
      }

      // Apply flash mode
      switch (_settings.flashMode) {
        case FlashMode.auto:
          await _controller!.setFlashMode(camera.FlashMode.auto);
          break;
        case FlashMode.on:
          await _controller!.setFlashMode(camera.FlashMode.always);
          break;
        case FlashMode.off:
          await _controller!.setFlashMode(camera.FlashMode.off);
          break;
        case FlashMode.torch:
          await _controller!.setFlashMode(camera.FlashMode.torch);
          break;
      }

      notifyListeners();
    } catch (e) {
      _error = 'Failed to apply settings: $e';
      notifyListeners();
    }
  }

  void updateShutterSpeed(double speed) {
    _settings.shutterSpeed = speed;
    notifyListeners();
  }

  void updateExposureTime(double time) {
    _settings.exposureTime = time;
    applySettings();
  }

  void updateISO(double iso) {
    _settings.iso = iso;
    notifyListeners();
  }

  void updateFocalLength(double length) {
    _settings.focalLength = length;
    notifyListeners();
  }

  void togglePortraitMode() {
    _settings.portraitMode = !_settings.portraitMode;
    notifyListeners();
  }

  void updateWhiteBalance(double balance) {
    _settings.whiteBalance = balance;
    notifyListeners();
  }

  void setFocusMode(FocusMode mode) {
    _settings.focusMode = mode;
    applySettings();
  }

  void toggleGrid() {
    _settings.gridOverlay = !_settings.gridOverlay;
    notifyListeners();
  }

  void toggleHistogram() {
    _settings.showHistogram = !_settings.showHistogram;
    notifyListeners();
  }

  void setFlashMode(FlashMode mode) {
    _settings.flashMode = mode;
    applySettings();
  }

  Future<String?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return null;
    }

    try {
      final image = await _controller!.takePicture();
      return image.path;
    } catch (e) {
      _error = 'Failed to take picture: $e';
      notifyListeners();
      return null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
