import 'package:google_ml_kit/google_ml_kit.dart';

/// Service for AI-powered features using ML Kit
class AIService {
  // Face detection
  final FaceDetector _faceDetector = GoogleMlKit.vision.faceDetector(
    FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: true,
    ),
  );

  // Image labeling for scene detection
  final ImageLabeler _imageLabeler = GoogleMlKit.vision.imageLabeler(
    ImageLabelerOptions(confidenceThreshold: 0.5),
  );

  /// Detect faces in an image for portrait mode
  Future<List<Face>> detectFaces(InputImage inputImage) async {
    try {
      final faces = await _faceDetector.processImage(inputImage);
      return faces;
    } catch (e) {
      print('Face detection error: $e');
      return [];
    }
  }

  /// Detect scene/objects in an image
  Future<List<ImageLabel>> detectScene(InputImage inputImage) async {
    try {
      final labels = await _imageLabeler.processImage(inputImage);
      return labels;
    } catch (e) {
      print('Scene detection error: $e');
      return [];
    }
  }

  /// Generate smart tags based on detected objects
  Future<List<String>> generateSmartTags(InputImage inputImage) async {
    try {
      final labels = await detectScene(inputImage);
      return labels
          .where((label) => label.confidence > 0.7)
          .map((label) => label.label.toLowerCase())
          .toList();
    } catch (e) {
      print('Tag generation error: $e');
      return [];
    }
  }

  /// Analyze image for auto-enhance suggestions
  Future<Map<String, double>> analyzeForEnhancement(InputImage inputImage) async {
    // This would use more sophisticated ML models in production
    // For now, return default enhancement values
    return {
      'brightness': 1.1,
      'contrast': 1.15,
      'saturation': 1.1,
      'sharpness': 1.05,
    };
  }

  /// Check if portrait mode should be enabled based on scene
  Future<bool> shouldEnablePortraitMode(InputImage inputImage) async {
    final faces = await detectFaces(inputImage);
    // Enable portrait mode if faces are detected
    return faces.isNotEmpty;
  }

  /// Detect best focus point in the scene
  Future<Offset?> detectFocusPoint(InputImage inputImage, Size imageSize) async {
    final faces = await detectFaces(inputImage);
    
    if (faces.isNotEmpty) {
      // Focus on the first detected face
      final face = faces.first;
      final boundingBox = face.boundingBox;
      return Offset(
        boundingBox.center.dx,
        boundingBox.center.dy,
      );
    }
    
    // Default to center if no faces detected
    return Offset(imageSize.width / 2, imageSize.height / 2);
  }

  /// Dispose resources
  void dispose() {
    _faceDetector.close();
    _imageLabeler.close();
  }
}
