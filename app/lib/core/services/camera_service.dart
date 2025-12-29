import 'dart:typed_data';

import 'package:camaroo/utils/app_constants.dart';
import 'package:camaroo/core/abstractions/camera_api.dart';
import 'package:native_camera_kit/native_camera_kit.dart';
import 'package:storage/storage.dart';

class CameraApiModel implements CameraApi {
  CameraApiModel({required StorageService storageService}) : _storageService = storageService;

  final StorageService _storageService;


  CameraStatus _cameraStatus = CameraStatus.uninitialized;
  NativeCameraController? _cameraController;
  String? _errorMessage;
  FlashMode _flashMode = FlashMode.off;

  

  // Camera Status
  @override
  CameraStatus get status => _cameraStatus;

  @override
  Function(CameraStatus) onStatusChanged = (status) {};

  @override
  void setStatus(CameraStatus newStatus) {
    _cameraStatus = newStatus;
    onStatusChanged(newStatus);
  }


  // Camera Controller
  @override
  NativeCameraController? get cameraNativeController => _cameraController;
  void setCameraNativeController(NativeCameraController? newCameraNativeController) => _cameraController = newCameraNativeController;
  


  // Flash Mode
  @override
  FlashMode get flashMode => _flashMode;

  @override
  Function(FlashMode) onFlashModeChanged = (flash) {};

  @override
  void setFlashMode(FlashMode newFlashMode) {
    _flashMode = newFlashMode;
    onFlashModeChanged(newFlashMode);
  }

  // Error Message
  @override
  String? get errorMessage => _errorMessage;

  @override
  Function(String?) onErrorMessageChanged = (errorMessage) {};

  @override
  void setErrorMessage(String? newErrorMessage) {
    _errorMessage = newErrorMessage;
    onErrorMessageChanged(newErrorMessage);
  }

  // ============================================================================
  // PUBLIC METHODS
  // ============================================================================

  @override
  Future<void> initializeCamera() async {
    setStatus(CameraStatus.initializing);
    setErrorMessage(null);

    try {
      // Create controller if it doesn't exist
      if (_cameraController == null) {
        _cameraController = NativeCameraController();
        setCameraNativeController(_cameraController);
      }

      // Initialize with default (back camera)
      final controller = _cameraController; // Linter Cheating. 
      if (controller == null) {
        throw Exception('Camera controller is null');
      }
      await controller.initializeDefault();
      setStatus(CameraStatus.ready);
    } catch (e) {
      setErrorMessage('${AppConstants.unexpectedError} $e');
      setStatus(CameraStatus.error);
    }
  }

  @override
  Future<void> switchCamera() async {
    final controller = _cameraController; // Linter Cheating. 
    if (controller == null) {
      throw Exception('Camera controller is null');
    }
    final availableCameras = controller.availableCameras;
    if (availableCameras == null || availableCameras.isEmpty) {
      throw Exception('No cameras available');
    }
    final nextCamera = availableCameras.firstWhere((camera) => camera.id != controller.currentCamera?.id);

    print('Focal length: ${controller.focalLength.value}');
    await controller.switchCamera(nextCamera);
   
  }

  @override
  Future<void> toggleFlash() async {
    FlashMode newMode;
    switch (_flashMode) {
      case FlashMode.off:
        newMode = FlashMode.auto;
        break;
      case FlashMode.auto:
        newMode = FlashMode.on;
        break;
      case FlashMode.on:
        newMode = FlashMode.torch;
        break;
      case FlashMode.torch:
        newMode = FlashMode.off;
        break;
    }
    final controller = _cameraController; // Linter Cheating. 
    if (controller == null) {
      throw Exception('Camera controller is null');
    }
    await controller.setFlashMode(newMode);
    setFlashMode(newMode);
  }
  
  @override
  Future<Uint8List> takePicture() async {
    setStatus(CameraStatus.takingPicture);
    setErrorMessage(null);
    
    try {
      final controller = _cameraController; // Linter Cheating. 
      if (controller == null) {
        throw Exception('Camera controller is null');
      }
      final image = await controller.takePicture();
      
      // Save to storage
      // final photo = Photo(
      //   id: DateTime.now().millisecondsSinceEpoch.toString(),
      //   filePath: '${DateTime.now().millisecondsSinceEpoch}.jpg',
      //   capturedAt: DateTime.now(),
      // );
      
      // TODO: Save image data to file
      // await _storageService.photos.savePhoto(photo);
      
      setStatus(CameraStatus.ready);
      return image;
    } catch (e) {
      setErrorMessage('Failed to take picture: $e');
      setStatus(CameraStatus.error);
      rethrow;
    }
  }

  // ============================================================================
  // PRIVATE HELPERS
  // ============================================================================



}
