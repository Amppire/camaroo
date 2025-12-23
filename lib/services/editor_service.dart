import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class EditorService extends ChangeNotifier {
  img.Image? _originalImage;
  img.Image? _editedImage;
  String? _currentImagePath;
  bool _isProcessing = false;

  img.Image? get editedImage => _editedImage;
  bool get isProcessing => _isProcessing;
  String? get currentImagePath => _currentImagePath;

  Future<void> loadImage(String path) async {
    _isProcessing = true;
    notifyListeners();

    try {
      final bytes = await File(path).readAsBytes();
      _originalImage = img.decodeImage(bytes);
      _editedImage = img.copyResize(_originalImage!,
          width: _originalImage!.width, height: _originalImage!.height);
      _currentImagePath = path;
    } catch (e) {
      debugPrint('Failed to load image: $e');
    }

    _isProcessing = false;
    notifyListeners();
  }

  void resetImage() {
    if (_originalImage != null) {
      _editedImage = img.copyResize(_originalImage!,
          width: _originalImage!.width, height: _originalImage!.height);
      notifyListeners();
    }
  }

  // Basic adjustments
  void adjustBrightness(double value) {
    if (_editedImage == null) return;
    _isProcessing = true;
    notifyListeners();

    _editedImage = img.adjustColor(_editedImage!,
        brightness: value,
    );

    _isProcessing = false;
    notifyListeners();
  }

  void adjustContrast(double value) {
    if (_editedImage == null) return;
    _isProcessing = true;
    notifyListeners();

    _editedImage = img.adjustColor(_editedImage!,
        contrast: value,
    );

    _isProcessing = false;
    notifyListeners();
  }

  void adjustSaturation(double value) {
    if (_editedImage == null) return;
    _isProcessing = true;
    notifyListeners();

    _editedImage = img.adjustColor(_editedImage!,
        saturation: value,
    );

    _isProcessing = false;
    notifyListeners();
  }

  // Filters
  void applyGrayscale() {
    if (_editedImage == null) return;
    _isProcessing = true;
    notifyListeners();

    _editedImage = img.grayscale(_editedImage!);

    _isProcessing = false;
    notifyListeners();
  }

  void applySepia() {
    if (_editedImage == null) return;
    _isProcessing = true;
    notifyListeners();

    _editedImage = img.sepia(_editedImage!);

    _isProcessing = false;
    notifyListeners();
  }

  void applyVintage() {
    if (_editedImage == null) return;
    _isProcessing = true;
    notifyListeners();

    // Apply vintage effect by combining adjustments
    _editedImage = img.adjustColor(_editedImage!,
        contrast: 1.2,
        saturation: 0.8,
    );
    _editedImage = img.vignette(_editedImage!);

    _isProcessing = false;
    notifyListeners();
  }

  void applyBlur(double radius) {
    if (_editedImage == null) return;
    _isProcessing = true;
    notifyListeners();

    _editedImage = img.gaussianBlur(_editedImage!, radius: radius.toInt());

    _isProcessing = false;
    notifyListeners();
  }

  void applySharpen() {
    if (_editedImage == null) return;
    _isProcessing = true;
    notifyListeners();

    // Apply convolution for sharpening
    _editedImage = img.convolution(_editedImage!, [
      0, -1, 0,
      -1, 5, -1,
      0, -1, 0,
    ]);

    _isProcessing = false;
    notifyListeners();
  }

  // Transform operations
  void rotate90() {
    if (_editedImage == null) return;
    _isProcessing = true;
    notifyListeners();

    _editedImage = img.copyRotate(_editedImage!, angle: 90);

    _isProcessing = false;
    notifyListeners();
  }

  void flipHorizontal() {
    if (_editedImage == null) return;
    _isProcessing = true;
    notifyListeners();

    _editedImage = img.flipHorizontal(_editedImage!);

    _isProcessing = false;
    notifyListeners();
  }

  void flipVertical() {
    if (_editedImage == null) return;
    _isProcessing = true;
    notifyListeners();

    _editedImage = img.flipVertical(_editedImage!);

    _isProcessing = false;
    notifyListeners();
  }

  void crop(int x, int y, int width, int height) {
    if (_editedImage == null) return;
    _isProcessing = true;
    notifyListeners();

    _editedImage = img.copyCrop(_editedImage!, 
      x: x, 
      y: y, 
      width: width, 
      height: height
    );

    _isProcessing = false;
    notifyListeners();
  }

  // AI-powered auto-enhance
  Future<void> autoEnhance() async {
    if (_editedImage == null) return;
    _isProcessing = true;
    notifyListeners();

    // Apply automatic adjustments
    _editedImage = img.adjustColor(_editedImage!,
        brightness: 1.1,
        contrast: 1.15,
        saturation: 1.1,
    );

    _isProcessing = false;
    notifyListeners();
  }

  Future<String> saveImage(String outputPath) async {
    if (_editedImage == null) {
      throw Exception('No image to save');
    }

    _isProcessing = true;
    notifyListeners();

    try {
      final bytes = img.encodeJpg(_editedImage!, quality: 95);
      await File(outputPath).writeAsBytes(bytes);
      
      _isProcessing = false;
      notifyListeners();
      return outputPath;
    } catch (e) {
      _isProcessing = false;
      notifyListeners();
      throw Exception('Failed to save image: $e');
    }
  }

  Uint8List? getImageBytes() {
    if (_editedImage == null) return null;
    return Uint8List.fromList(img.encodeJpg(_editedImage!, quality: 85));
  }
}
