import AVFoundation
import Flutter
import UIKit

/// Native iOS Camera Implementation using AVFoundation
/// Provides seamless camera switching with hardware-level focal length control
public class NativeCameraKitPlugin: NSObject, FlutterPlugin, NativeCameraApi {
  private var flutterApi: NativeCameraFlutterApi?
  private var textureRegistry: FlutterTextureRegistry?
  
  // Camera state
  private var captureSession: AVCaptureSession?
  private var videoDataOutput: AVCaptureVideoDataOutput?
  private var photoOutput: AVCapturePhotoOutput?
  private var currentDevice: AVCaptureDevice?
  private var currentDeviceInput: AVCaptureDeviceInput?
  
  // Texture for Flutter
  private var textureId: Int64?
  private var latestPixelBuffer: CVPixelBuffer?
  private var textureRenderer: FlutterTextureRenderer?
  
  // Camera devices cache
  private var availableDevices: [AVCaptureDevice] = []
  
  // State
  private var isInitialized = false
  private var currentFlashMode: FlashMode = .off
  
  // Photo capture delegates - need to retain them during capture
  private var photoCaptureDelegate: PhotoCaptureDelegate?
  
  // MARK: - Helper Functions
  
  /// Calculate focal length from device format
  private func calculateFocalLength(from device: AVCaptureDevice) -> Double {
    let fov = Double(device.activeFormat.videoFieldOfView)
    let dimensions = CMVideoFormatDescriptionGetDimensions(device.activeFormat.formatDescription)
    let sensorWidth = Double(dimensions.width) / 1000.0 // Convert to mm
    // Formula: focalLength = (sensorWidth / 2) / tan(fov / 2)
    let focalLength = (sensorWidth / 2.0) / tan(fov * .pi / 180.0 / 2.0)
    return focalLength
  }
  
  // MARK: - Plugin Registration
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger = registrar.messenger()
    let textureRegistry = registrar.textures()
    
    let plugin = NativeCameraKitPlugin()
    plugin.textureRegistry = textureRegistry
    
    // Setup Pigeon APIs
    NativeCameraApiSetup.setUp(binaryMessenger: messenger, api: plugin)
    plugin.flutterApi = NativeCameraFlutterApi(binaryMessenger: messenger)
  }
  
  // MARK: - NativeCameraApi Implementation
  
  func getAvailableCameras() throws -> [CameraDevice] {
    // Discover all available cameras
    let discoverySession = AVCaptureDevice.DiscoverySession(
      deviceTypes: [
        .builtInWideAngleCamera,
        .builtInTelephotoCamera,
        .builtInUltraWideCamera,
        .builtInTrueDepthCamera
      ],
      mediaType: .video,
      position: .unspecified
    )
    
    let allDevices = discoverySession.devices
    
    // Deduplicate front cameras (TrueDepth camera IS the front camera)
    // Check if we have a TrueDepth camera for front position
    let hasTrueDepthFront = allDevices.contains { 
      $0.position == .front && $0.deviceType == .builtInTrueDepthCamera 
    }
    
    // Filter out generic front wide angle camera if we have TrueDepth
    availableDevices = allDevices.filter { device in
      // If this is a front wide angle camera and we have TrueDepth, skip it
      if device.position == .front && 
         device.deviceType == .builtInWideAngleCamera && 
         hasTrueDepthFront {
        return false
      }
      return true
    }
    
    return availableDevices.map { device -> CameraDevice in
      let focalLength = calculateFocalLength(from: device)
      
      return CameraDevice(
        id: device.uniqueID,
        name: device.localizedName,
        position: device.position == .back ? .back : .front,
        focalLength: focalLength,
        minFocalLength: focalLength, // Base focal length
        maxFocalLength: focalLength * Double(device.activeFormat.videoMaxZoomFactor),
        fieldOfView: Double(device.activeFormat.videoFieldOfView),
        hasFlash: device.hasFlash
      )
    }
  }
  
  func initializeCamera(cameraId: String, completion: @escaping (Result<CameraConfig, Error>) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self = self else {
        completion(.failure(NSError(domain: "NativeCameraKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Plugin deallocated"])))
        return
      }
      
      do {
        // Notify status change
        self.flutterApi?.onStatusChanged(status: .initializing, completion: { _ in })
        
        // Find device
        guard let device = self.availableDevices.first(where: { $0.uniqueID == cameraId }) else {
          throw NSError(domain: "NativeCameraKit", code: -2, userInfo: [NSLocalizedDescriptionKey: "Camera not found: \(cameraId)"])
        }
        
        // Create session if needed
        if self.captureSession == nil {
          self.captureSession = AVCaptureSession()
          self.captureSession?.sessionPreset = .photo
        }
        
        guard let session = self.captureSession else {
          throw NSError(domain: "NativeCameraKit", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to create capture session"])
        }
        
        session.beginConfiguration()
        
        // Remove old input
        if let oldInput = self.currentDeviceInput {
          session.removeInput(oldInput)
        }
        
        // Add new input
        let input = try AVCaptureDeviceInput(device: device)
        if session.canAddInput(input) {
          session.addInput(input)
          self.currentDeviceInput = input
          self.currentDevice = device
        } else {
          throw NSError(domain: "NativeCameraKit", code: -4, userInfo: [NSLocalizedDescriptionKey: "Cannot add input"])
        }
        
        // Setup video output for preview (if not already added)
        if self.videoDataOutput == nil {
          let videoOutput = AVCaptureVideoDataOutput()
          videoOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)
          ]
          videoOutput.alwaysDiscardsLateVideoFrames = true
          
          let queue = DispatchQueue(label: "com.camaroo.native_camera_kit.video")
          videoOutput.setSampleBufferDelegate(self, queue: queue)
          
          if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            self.videoDataOutput = videoOutput
            
            // Set orientation to portrait
            if let connection = videoOutput.connection(with: .video) {
              if connection.isVideoOrientationSupported {
                connection.videoOrientation = .portrait
              }
              // Mirror front camera
              if connection.isVideoMirroringSupported {
                connection.isVideoMirrored = device.position == .front
              }
            }
          }
        } else {
          // Update orientation for camera switches
          if let connection = self.videoDataOutput?.connection(with: .video) {
            if connection.isVideoOrientationSupported {
              connection.videoOrientation = .portrait
            }
            if connection.isVideoMirroringSupported {
              connection.isVideoMirrored = device.position == .front
            }
          }
        }
        
        // Setup photo output (if not already added)
        if self.photoOutput == nil {
          let photoOutput = AVCapturePhotoOutput()
          photoOutput.isHighResolutionCaptureEnabled = true
          
          if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
            self.photoOutput = photoOutput
          }
        }
        
        session.commitConfiguration()
        
        // Create texture for Flutter
        if self.textureId == nil {
          let renderer = FlutterTextureRenderer()
          self.textureRenderer = renderer
          self.textureId = self.textureRegistry?.register(renderer)
        }
        
        // Start session
        if !session.isRunning {
          session.startRunning()
        }
        
        // Ensure orientation is set after session starts
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
          if let connection = self?.videoDataOutput?.connection(with: .video) {
            if connection.isVideoOrientationSupported {
              connection.videoOrientation = .portrait
            }
            if connection.isVideoMirroringSupported, let device = self?.currentDevice {
              connection.isVideoMirrored = device.position == .front
            }
          }
        }
        
        self.isInitialized = true
        
        // Get preview size
        let dimensions = CMVideoFormatDescriptionGetDimensions(device.activeFormat.formatDescription)
        let width = Int(dimensions.width)
        let height = Int(dimensions.height)
        
        let config = CameraConfig(
          textureId: self.textureId ?? -1,
          width: Int64(width),
          height: Int64(height)
        )
        
        // Update focal length range
        let minFocal = calculateFocalLength(from: device)
        let maxFocal = minFocal * Double(device.activeFormat.videoMaxZoomFactor)
        
        DispatchQueue.main.async {
          self.flutterApi?.onStatusChanged(status: .ready, completion: { _ in })
          self.flutterApi?.onFocalLengthChanged(focalLength: minFocal, completion: { _ in })
          self.flutterApi?.onFocalLengthRangeChanged(min: minFocal, max: maxFocal, completion: { _ in })
        }
        
        completion(.success(config))
        
      } catch {
        DispatchQueue.main.async {
          let cameraError = CameraError(
            code: "INITIALIZATION_FAILED",
            message: error.localizedDescription
          )
          self.flutterApi?.onError(error: cameraError, completion: { _ in })
          self.flutterApi?.onStatusChanged(status: .error, completion: { _ in })
        }
        completion(.failure(error))
      }
    }
  }
  
  func switchCamera(cameraId: String, completion: @escaping (Result<Void, Error>) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self = self else {
        completion(.failure(NSError(domain: "NativeCameraKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "Plugin deallocated"])))
        return
      }
      
      guard let session = self.captureSession else {
        completion(.failure(NSError(domain: "NativeCameraKit", code: -5, userInfo: [NSLocalizedDescriptionKey: "Session not initialized"])))
        return
      }
      
      do {
        // Find new device
        guard let newDevice = self.availableDevices.first(where: { $0.uniqueID == cameraId }) else {
          throw NSError(domain: "NativeCameraKit", code: -2, userInfo: [NSLocalizedDescriptionKey: "Camera not found: \(cameraId)"])
        }
        
        session.beginConfiguration()
        
        // Remove old input
        if let oldInput = self.currentDeviceInput {
          session.removeInput(oldInput)
        }
        
        // Add new input
        let newInput = try AVCaptureDeviceInput(device: newDevice)
        if session.canAddInput(newInput) {
          session.addInput(newInput)
          self.currentDeviceInput = newInput
          self.currentDevice = newDevice
        } else {
          throw NSError(domain: "NativeCameraKit", code: -4, userInfo: [NSLocalizedDescriptionKey: "Cannot add input"])
        }
        
        // Update video connection orientation for new camera
        if let connection = self.videoDataOutput?.connection(with: .video) {
          if connection.isVideoOrientationSupported {
            connection.videoOrientation = .portrait
          }
          if connection.isVideoMirroringSupported {
            connection.isVideoMirrored = newDevice.position == .front
          }
        }
        
        session.commitConfiguration()
        
        // Update focal length
        let newFocalLength = calculateFocalLength(from: newDevice)
        let maxFocal = newFocalLength * Double(newDevice.activeFormat.videoMaxZoomFactor)
        
        DispatchQueue.main.async {
          self.flutterApi?.onFocalLengthChanged(focalLength: newFocalLength, completion: { _ in })
          self.flutterApi?.onFocalLengthRangeChanged(min: newFocalLength, max: maxFocal, completion: { _ in })
        }
        
        completion(.success(()))
        
      } catch {
        DispatchQueue.main.async {
          let cameraError = CameraError(
            code: "SWITCH_FAILED",
            message: error.localizedDescription
          )
          self.flutterApi?.onError(error: cameraError, completion: { _ in })
        }
        completion(.failure(error))
      }
    }
  }
  
  func setFocalLength(focalLengthMm: Double, completion: @escaping (Result<Void, Error>) -> Void) {
    guard let currentDevice = currentDevice else {
      completion(.failure(NSError(domain: "NativeCameraKit", code: -6, userInfo: [NSLocalizedDescriptionKey: "No active device"])))
      return
    }
    
    // Get all back cameras (only switch between back cameras)
    let backCameras = availableDevices.filter { $0.position == currentDevice.position }
    
    // Find the best camera for this focal length
    var bestCamera: AVCaptureDevice?
    var bestDigitalZoom: Double = Double.infinity
    
    print("📷 Finding best camera for \(focalLengthMm)mm")
    
    for camera in backCameras {
      let cameraBaseFocalLength = calculateFocalLength(from: camera)
      let requiredZoom = focalLengthMm / cameraBaseFocalLength
      
      print("  - \(camera.localizedName): base=\(String(format: "%.1f", cameraBaseFocalLength))mm, needs \(String(format: "%.2f", requiredZoom))x zoom")
      
      // Check if this camera can reach the target focal length
      if requiredZoom >= camera.minAvailableVideoZoomFactor &&
         requiredZoom <= camera.activeFormat.videoMaxZoomFactor {
        // Prefer cameras that need less digital zoom (closer to 1.0x)
        let digitalZoomAmount = abs(requiredZoom - 1.0)
        
        if digitalZoomAmount < bestDigitalZoom {
          bestDigitalZoom = digitalZoomAmount
          bestCamera = camera
          print("    ✓ Best so far (digital zoom: \(String(format: "%.2f", digitalZoomAmount)))")
        }
      }
    }
    
    if let best = bestCamera {
      print("🎯 Selected: \(best.localizedName)")
    }
    
    // Use current camera if no better option found
    guard let targetCamera = bestCamera ?? backCameras.first else {
      completion(.failure(NSError(domain: "NativeCameraKit", code: -6, userInfo: [NSLocalizedDescriptionKey: "No suitable camera found"])))
      return
    }
    
    // Calculate final focal length values
    let targetBaseFocalLength = calculateFocalLength(from: targetCamera)
    let targetZoomFactor = focalLengthMm / targetBaseFocalLength
    let clampedZoom = max(targetCamera.minAvailableVideoZoomFactor, 
                          min(targetZoomFactor, targetCamera.activeFormat.videoMaxZoomFactor))
    
    // Switch camera if different from current
    if targetCamera.uniqueID != currentDevice.uniqueID {
      print("🔄 Switching from \(currentDevice.localizedName) to \(targetCamera.localizedName) for \(focalLengthMm)mm")
      
      // Switch camera first
      switchCamera(cameraId: targetCamera.uniqueID) { [weak self] result in
        switch result {
        case .success:
          // After switching, apply the zoom
          self?.applyZoomToCurrentCamera(zoomFactor: clampedZoom, targetFocalLength: focalLengthMm, completion: completion)
        case .failure(let error):
          completion(.failure(error))
        }
      }
    } else {
      // Same camera, just apply zoom
      applyZoomToCurrentCamera(zoomFactor: clampedZoom, targetFocalLength: focalLengthMm, completion: completion)
    }
  }
  
  /// Helper function to apply zoom to the current camera
  private func applyZoomToCurrentCamera(zoomFactor: Double, targetFocalLength: Double, completion: @escaping (Result<Void, Error>) -> Void) {
    guard let device = currentDevice else {
      completion(.failure(NSError(domain: "NativeCameraKit", code: -6, userInfo: [NSLocalizedDescriptionKey: "No active device"])))
      return
    }
    
    do {
      try device.lockForConfiguration()
      device.videoZoomFactor = zoomFactor
      device.unlockForConfiguration()
      
      // Notify Flutter with actual focal length
      let baseFocalLength = calculateFocalLength(from: device)
      let actualFocalLength = baseFocalLength * zoomFactor
      
      DispatchQueue.main.async { [weak self] in
        self?.flutterApi?.onFocalLengthChanged(focalLength: actualFocalLength, completion: { _ in })
        
        // Also update focal length range for the new camera
        let minFL = baseFocalLength * device.minAvailableVideoZoomFactor
        let maxFL = baseFocalLength * device.activeFormat.videoMaxZoomFactor
        self?.flutterApi?.onFocalLengthRangeChanged(min: minFL, max: maxFL, completion: { _ in })
      }
      
      completion(.success(()))
      
    } catch {
      completion(.failure(error))
    }
  }
  
  func setFlashMode(mode: FlashMode) throws {
    currentFlashMode = mode
    // Flash is applied when taking photo
  }
  
  func takePicture(completion: @escaping (Result<PhotoResult, Error>) -> Void) {
    guard let photoOutput = self.photoOutput else {
      completion(.failure(NSError(domain: "NativeCameraKit", code: -7, userInfo: [NSLocalizedDescriptionKey: "Photo output not initialized"])))
      return
    }
    
    print("📸 takePicture called")
    
    DispatchQueue.main.async { [weak self] in
      self?.flutterApi?.onStatusChanged(status: .takingPicture, completion: { _ in })
    }
    
    let settings = AVCapturePhotoSettings()
    
    // Set flash mode
    if let device = currentDevice, device.hasFlash {
      switch currentFlashMode {
      case .off:
        settings.flashMode = .off
      case .on:
        settings.flashMode = .on
      case .auto:
        settings.flashMode = .auto
      case .torch:
        settings.flashMode = .on // Torch is for video, use on for photo
      }
    }
    
    settings.isHighResolutionPhotoEnabled = true
    
    // Retain the delegate until photo capture completes
    photoCaptureDelegate = PhotoCaptureDelegate { [weak self] result in
      print("📸 Photo capture completed")
      DispatchQueue.main.async {
        self?.flutterApi?.onStatusChanged(status: .ready, completion: { _ in })
        // Clear the delegate after completion
        self?.photoCaptureDelegate = nil
      }
      completion(result)
    }
    
    print("📸 Capturing photo with settings: \(settings)")
    photoOutput.capturePhoto(with: settings, delegate: photoCaptureDelegate!)
  }
  
  func dispose() throws {
    captureSession?.stopRunning()
    
    if let textureId = textureId {
      textureRegistry?.unregisterTexture(textureId)
      self.textureId = nil
    }
    
    captureSession = nil
    videoDataOutput = nil
    photoOutput = nil
    currentDevice = nil
    currentDeviceInput = nil
    textureRenderer = nil
    isInitialized = false
  }
  
  func pause() throws {
    captureSession?.stopRunning()
  }
  
  func resume() throws {
    if isInitialized {
      captureSession?.startRunning()
    }
  }
}

// MARK: - Video Sample Buffer Delegate

extension NativeCameraKitPlugin: AVCaptureVideoDataOutputSampleBufferDelegate {
  public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
      return
    }
    
    latestPixelBuffer = pixelBuffer
    
    // Notify texture to update
    if let textureId = textureId {
      textureRenderer?.setPixelBuffer(pixelBuffer)
      textureRegistry?.textureFrameAvailable(textureId)
    }
  }
}

// MARK: - Photo Capture Delegate

private class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
  private let completion: (Result<PhotoResult, Error>) -> Void
  
  init(completion: @escaping (Result<PhotoResult, Error>) -> Void) {
    self.completion = completion
    super.init()
  }
  
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    print("📸 photoOutput delegate called")
    
    if let error = error {
      print("📸 Error capturing photo: \(error.localizedDescription)")
      completion(.failure(error))
      return
    }
    
    guard let imageData = photo.fileDataRepresentation() else {
      print("📸 Failed to get image data representation")
      completion(.failure(NSError(domain: "NativeCameraKit", code: -8, userInfo: [NSLocalizedDescriptionKey: "Failed to get image data"])))
      return
    }
    
    print("📸 Got image data: \(imageData.count) bytes")
    
    // Get image dimensions
    if let image = UIImage(data: imageData) {
      // Convert Data to FlutterStandardTypedData (Uint8List for Flutter)
      let flutterData = FlutterStandardTypedData(bytes: imageData)
      
      let result = PhotoResult(
        data: flutterData,
        width: Int64(image.size.width * image.scale),
        height: Int64(image.size.height * image.scale)
      )
      print("📸 Photo result created: \(result.width)x\(result.height)")
      completion(.success(result))
    } else {
      print("📸 Failed to decode image from data")
      completion(.failure(NSError(domain: "NativeCameraKit", code: -9, userInfo: [NSLocalizedDescriptionKey: "Failed to decode image"])))
    }
  }
}

// MARK: - Texture Renderer

private class FlutterTextureRenderer: NSObject, FlutterTexture {
  private var pixelBuffer: CVPixelBuffer?
  private let lock = NSLock()
  
  func setPixelBuffer(_ buffer: CVPixelBuffer) {
    lock.lock()
    pixelBuffer = buffer
    lock.unlock()
  }
  
  func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
    lock.lock()
    defer { lock.unlock() }
    
    guard let buffer = pixelBuffer else {
      return nil
    }
    
    return Unmanaged.passRetained(buffer)
  }
}
